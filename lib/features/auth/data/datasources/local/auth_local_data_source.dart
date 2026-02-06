import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:yb_news/core/storage/secure_storage.dart';
import 'package:yb_news/features/auth/data/models/local_user_record.dart';

abstract class AuthLocalDataSource {
  Future<LocalUserRecord?> findByEmail(String email);
  Future<void> updateIsFirstLogin(String email, bool isFirstLogin);
  Future<bool> emailExists(String email);
  Future<void> createUser({
    required String email,
    required String password,
  });
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._storage);

  final SecureStorage _storage;

  static const _seedPath = 'assets/data/users.json';
  static const _overrideKey = 'auth_user_overrides_v1';
  static const _createdKey = 'auth_user_created_v1';

  List<LocalUserRecord>? _seedCache;

  @override
  Future<LocalUserRecord?> findByEmail(String email) async {
    final normalized = email.trim().toLowerCase();
    final seed = await _loadSeed();
    final overrides = await _loadOverrides();
    final created = await _loadCreated();

    final record = created[normalized] ??
        seed.firstWhere(
          (u) => u.email.toLowerCase() == normalized,
          orElse: () => LocalUserRecord(
            id: '',
            email: '',
            password: '',
            isFirstLogin: false,
          ),
        );

    if (record.email.isEmpty) return null;

    final override = overrides[normalized];
    if (override == null) return record;

    return record.copyWith(
      isFirstLogin: override['isFirstLogin'] as bool? ?? record.isFirstLogin,
    );
  }

  @override
  Future<bool> emailExists(String email) async {
    final normalized = email.trim().toLowerCase();
    final created = await _loadCreated();
    if (created.containsKey(normalized)) return true;
    final seed = await _loadSeed();
    return seed.any((u) => u.email.toLowerCase() == normalized);
  }

  @override
  Future<void> createUser({
    required String email,
    required String password,
  }) async {
    final normalized = email.trim().toLowerCase();
    final created = await _loadCreated();
    created[normalized] = LocalUserRecord(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: normalized,
      password: password,
      isFirstLogin: true,
    );
    await _storage.write(_createdKey, jsonEncode(_encodeCreated(created)));
  }

  @override
  Future<void> updateIsFirstLogin(String email, bool isFirstLogin) async {
    final normalized = email.trim().toLowerCase();
    final overrides = await _loadOverrides();
    overrides[normalized] = {
      'isFirstLogin': isFirstLogin,
      'updatedAt': DateTime.now().toIso8601String(),
    };
    await _storage.write(_overrideKey, jsonEncode(overrides));
  }

  Future<List<LocalUserRecord>> _loadSeed() async {
    if (_seedCache != null) return _seedCache!;

    final raw = await rootBundle.loadString(_seedPath);
    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      _seedCache = const <LocalUserRecord>[];
      return _seedCache!;
    }

    _seedCache = decoded
        .whereType<Map<String, dynamic>>()
        .map(LocalUserRecord.fromJson)
        .toList(growable: false);
    return _seedCache!;
  }

  Future<Map<String, dynamic>> _loadOverrides() async {
    final raw = await _storage.read(_overrideKey);
    if (raw == null || raw.isEmpty) return {};
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) return decoded;
    return {};
  }

  Future<Map<String, LocalUserRecord>> _loadCreated() async {
    final raw = await _storage.read(_createdKey);
    if (raw == null || raw.isEmpty) return {};
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) return {};
    final result = <String, LocalUserRecord>{};
    decoded.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        result[key] = LocalUserRecord.fromJson(value);
      }
    });
    return result;
  }

  Map<String, dynamic> _encodeCreated(
    Map<String, LocalUserRecord> created,
  ) {
    final map = <String, dynamic>{};
    created.forEach((key, value) {
      map[key] = {
        'id': value.id,
        'email': value.email,
        'password': value.password,
        'isFirstLogin': value.isFirstLogin,
      };
    });
    return map;
  }
}
