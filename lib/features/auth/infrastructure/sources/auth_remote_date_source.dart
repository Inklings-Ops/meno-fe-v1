import 'package:meno/core/core.dart';
import 'package:meno/features/auth/infrastructure/infrastructure.dart';

final class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._client);

  final ApiClient _client;

  /// Login with email and password.
  ///
  /// Throws [MenoException] on failure.
  Future<UserCredentialDto> login(String email, String password) async {
    return _client.post(
      '/users/signin',
      data: {'email': email, 'password': password},
      fromJson: UserCredentialDto.fromJson,
    );
  }

  /// Register a new user account.
  ///
  /// Throws [MenoException] on failure.
  Future<UserCredentialDto> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    // Standard JSON request
    return _client.post(
      '/users/signup',
      data: {'fullName': fullName, 'email': email, 'password': password},
      fromJson: UserCredentialDto.fromJson,
    );
  }
}
