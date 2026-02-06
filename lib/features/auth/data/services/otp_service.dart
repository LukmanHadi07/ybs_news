import 'dart:convert';
import 'dart:math';

import 'package:yb_news/core/storage/secure_storage.dart';
import 'package:yb_news/features/auth/data/services/email_service.dart';

class OtpService {
  OtpService({
    required SecureStorage storage,
    required EmailService emailService,
    this.expirySeconds = 180,
  })  : _storage = storage,
        _emailService = emailService;

  final SecureStorage _storage;
  final EmailService _emailService;
  final int expirySeconds;

  static const _storageKey = 'auth_otp_records_v1';

  Future<OtpRecord> generateAndSend(String email) async {
    final normalized = email.trim().toLowerCase();
    final otp = _generateOtp();
    final now = DateTime.now();
    final record = OtpRecord(
      email: normalized,
      otp: otp,
      expiresAt: now.add(Duration(seconds: expirySeconds)),
      resendAvailableAt: now.add(Duration(seconds: expirySeconds)),
    );

    await _saveRecord(record);
    await _emailService.sendOtp(email: normalized, otp: otp);
    return record;
  }

  Future<OtpValidationResult> validate(String email, String otp) async {
    final normalized = email.trim().toLowerCase();
    final record = await _getRecord(normalized);
    if (record == null) return OtpValidationResult.invalid;

    final now = DateTime.now();
    if (now.isAfter(record.expiresAt)) {
      return OtpValidationResult.expired;
    }

    if (record.otp != otp.toUpperCase()) {
      return OtpValidationResult.invalid;
    }

    await _removeRecord(normalized);
    return OtpValidationResult.valid;
  }

  Future<bool> canResend(String email) async {
    final record = await _getRecord(email.trim().toLowerCase());
    if (record == null) return true;
    return DateTime.now().isAfter(record.resendAvailableAt);
  }

  String _generateOtp() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  Future<OtpRecord?> _getRecord(String email) async {
    final all = await _loadAll();
    final raw = all[email];
    if (raw is! Map<String, dynamic>) return null;
    return OtpRecord.fromJson(raw);
  }

  Future<void> _saveRecord(OtpRecord record) async {
    final all = await _loadAll();
    all[record.email] = record.toJson();
    await _storage.write(_storageKey, jsonEncode(all));
  }

  Future<void> _removeRecord(String email) async {
    final all = await _loadAll();
    all.remove(email);
    await _storage.write(_storageKey, jsonEncode(all));
  }

  Future<Map<String, dynamic>> _loadAll() async {
    final raw = await _storage.read(_storageKey);
    if (raw == null || raw.isEmpty) return {};
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) return decoded;
    return {};
  }
}

class OtpRecord {
  OtpRecord({
    required this.email,
    required this.otp,
    required this.expiresAt,
    required this.resendAvailableAt,
  });

  final String email;
  final String otp;
  final DateTime expiresAt;
  final DateTime resendAvailableAt;

  factory OtpRecord.fromJson(Map<String, dynamic> json) {
    return OtpRecord(
      email: json['email']?.toString() ?? '',
      otp: json['otp']?.toString() ?? '',
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        json['expiresAt'] as int? ?? 0,
      ),
      resendAvailableAt: DateTime.fromMillisecondsSinceEpoch(
        json['resendAvailableAt'] as int? ?? 0,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'expiresAt': expiresAt.millisecondsSinceEpoch,
      'resendAvailableAt': resendAvailableAt.millisecondsSinceEpoch,
    };
  }
}

enum OtpValidationResult { valid, invalid, expired }
