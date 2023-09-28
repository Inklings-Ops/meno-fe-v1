import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/features/auth/domain/domain.dart';
import 'package:meno_fe_v1/features/auth/infrastructure/datasources/auth_local_datasource.dart';
import 'package:meno_fe_v1/features/auth/infrastructure/datasources/auth_remote_datasource.dart';
import 'package:meno_fe_v1/features/auth/infrastructure/dtos/user_credentials_dto.dart';
import 'package:meno_fe_v1/features/auth/infrastructure/mapper/auth_mapper.dart';
import 'package:meno_fe_v1/features/auth/infrastructure/responses/auth_response.dart';

@LazySingleton(as: IAuthFacade)
class AuthFacade implements IAuthFacade {
  final AuthMapper _authMapper;
  final AuthRemoteDatasource _remote;
  final AuthLocalDatasource _local;

  AuthFacade({
    required AuthMapper authMapper,
    required AuthRemoteDatasource remoteDatasource,
    required AuthLocalDatasource localDatasource,
  })  : _authMapper = authMapper,
        _remote = remoteDatasource,
        _local = localDatasource;

  final _logger = Logger();

  @override
  Future<User> getUser() {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthException, Unit>> googleSignIn({bool isRegister = false}) {
    // TODO: implement googleSignIn
    throw UnimplementedError();
  }

  @override
  // TODO: implement isVerified
  Future<bool> get isVerified => throw UnimplementedError();

  @override
  Future<Either<AuthException, Unit>> login({
    required IEmail email,
    required IPassword password,
  }) async {
    final String emailValue = email.get()!;
    final String passwordValue = password.get()!;
    try {
      final AuthResponse<UserCredentialsDto> response = await _remote.login(
        email: emailValue,
        password: passwordValue,
      );

      final UserCredentialsDto userCredentialsDto = response.data!;
      await _local.storeToken(userCredentialsDto.token);
      await _local.storeUserCredentials(userCredentialsDto);

      return right(unit);
    } on DioException catch (e) {
      _logger.e(e);
      return left(const AuthException.serverError());
    }
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> partialLogout() {
    // TODO: implement partialLogout
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthException, Unit>> register(
      {required IFullName fullName,
      required IEmail email,
      required IPassword password,
      IBio? bio,
      IAvatar? avatar}) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  // TODO: implement userToken
  Future<UserToken> get userToken => throw UnimplementedError();
}
