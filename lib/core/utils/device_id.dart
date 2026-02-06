import 'package:yb_news/core/storage/secure_storage.dart';

class DeviceIdProvider {
  DeviceIdProvider(this._secureStorage);
  final SecureStorage _secureStorage;

  static const _key = 'device_id';

  Future<String> getOrCreate() async {
    final existing = await _secureStorage.read(_key);
    if (existing != null && existing.isNotEmpty) return existing;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await _secureStorage.write(_key, id);
    return id;
  }
}
