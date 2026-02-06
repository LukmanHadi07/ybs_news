import 'dart:convert';
import 'dart:math';

import 'package:yb_news/core/storage/secure_storage.dart';

class SessionService {
  SessionService({required SecureStorage storage, this.expiryHours = 24})
      : _storage = storage;

  final SecureStorage _storage;
  final int expiryHours;

  static const _storageKey = 'auth_sessions_v1';

  Future<SessionResult> createOrRefresh({
    required String email,
    required String deviceId,
  }) async {
    final normalized = email.trim().toLowerCase();
    final sessions = await _loadAll();
    final existing = sessions[normalized];
    final now = DateTime.now();

    if (existing is Map<String, dynamic>) {
      final record = SessionRecord.fromJson(existing);
      if (now.isBefore(record.expiresAt) && record.deviceId != deviceId) {
        return const SessionResult.blocked(
          'Account is already logged in on another device',
        );
      }
    }

    final newRecord = SessionRecord(
      sessionId: _generateSessionId(),
      deviceId: deviceId,
      createdAt: now,
      expiresAt: now.add(Duration(hours: expiryHours)),
    );

    sessions[normalized] = newRecord.toJson();
    await _storage.write(_storageKey, jsonEncode(sessions));

    return SessionResult.allowed(newRecord.sessionId);
  }

  Future<void> clear(String email) async {
    final normalized = email.trim().toLowerCase();
    final sessions = await _loadAll();
    sessions.remove(normalized);
    await _storage.write(_storageKey, jsonEncode(sessions));
  }

  Future<void> clearBySessionId(String sessionId) async {
    final sessions = await _loadAll();
    final keysToRemove = <String>[];
    sessions.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        final record = SessionRecord.fromJson(value);
        if (record.sessionId == sessionId) {
          keysToRemove.add(key);
        }
      }
    });
    for (final key in keysToRemove) {
      sessions.remove(key);
    }
    await _storage.write(_storageKey, jsonEncode(sessions));
  }

  String _generateSessionId() {
    final rand = Random.secure();
    final suffix = rand.nextInt(0xffffff).toRadixString(16).padLeft(6, '0');
    return 'sess_${DateTime.now().millisecondsSinceEpoch}_$suffix';
  }

  Future<Map<String, dynamic>> _loadAll() async {
    final raw = await _storage.read(_storageKey);
    if (raw == null || raw.isEmpty) return {};
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) return decoded;
    return {};
  }
}

class SessionRecord {
  SessionRecord({
    required this.sessionId,
    required this.deviceId,
    required this.createdAt,
    required this.expiresAt,
  });

  final String sessionId;
  final String deviceId;
  final DateTime createdAt;
  final DateTime expiresAt;

  factory SessionRecord.fromJson(Map<String, dynamic> json) {
    return SessionRecord(
      sessionId: json['sessionId']?.toString() ?? '',
      deviceId: json['deviceId']?.toString() ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        json['createdAt'] as int? ?? 0,
      ),
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        json['expiresAt'] as int? ?? 0,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'deviceId': deviceId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'expiresAt': expiresAt.millisecondsSinceEpoch,
    };
  }
}

class SessionResult {
  const SessionResult._(this.sessionId, this.errorMessage);

  final String? sessionId;
  final String? errorMessage;

  const SessionResult.allowed(String sessionId)
      : this._(sessionId, null);

  const SessionResult.blocked(String message) : this._(null, message);

  bool get isAllowed => sessionId != null;
}
