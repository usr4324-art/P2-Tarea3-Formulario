
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  static const String _tokenKey = 'jwt_token';

  // Save the authentication token
  Future<void> saveToken(String token) async {
    await _storage.write(
      key: _tokenKey,
      value: token,
    );
  }

  // Retrieve the authentication token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Delete the authentication token
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
