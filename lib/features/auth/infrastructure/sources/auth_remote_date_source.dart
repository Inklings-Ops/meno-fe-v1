import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/auth/infrastructure/infrastructure.dart';

final class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._client);

  final ApiClient _client;

  Future<Either<MenoException, UserCredentialDto>> login(
    String email,
    String password, {
    CancelToken? cancelToken,
  }) async {
    return _client.post(
      '/users/signin',
      data: {'email': email, 'password': password},
      fromJson: UserCredentialDto.fromJson,
      cancelToken: cancelToken,
    );
  }
}
