import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
    return token;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }

  Future<void> saveUserId(String id) async {
    await _storage.write(key: 'userId', value: id);
  }
}

// final secureStorageProvider = Provider<SecureStorage>((ref) {
//   return SecureStorage();
// });
