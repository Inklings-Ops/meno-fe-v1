import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class AuthLocalDataSource {
  const AuthLocalDataSource({required FlutterSecureStorage storage})
    : _storage = storage;

  final FlutterSecureStorage _storage;
}
