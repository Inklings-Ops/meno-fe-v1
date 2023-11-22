import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../services/jwt_service.dart';
import '../../../services/network_service.dart';
import '../domain/domain.dart';
import 'datasources/auth_local_datasource.dart';
import 'datasources/auth_remote_datasource.dart';
import 'dtos/dtos.dart';
import 'mapper/auth_mapper.dart';
import 'responses/auth_response.dart';

@LazySingleton(as: IAuthFacade)
class AuthFacade implements IAuthFacade {
  final AuthMapper _authMapper;
  final AuthRemoteDatasource _remote;
  final AuthLocalDatasource _local;
  final NetworkService _network;
  final JWTService _jwt;

  AuthFacade({
    required AuthMapper authMapper,
    required AuthRemoteDatasource remoteDatasource,
    required AuthLocalDatasource localDatasource,
    required NetworkService networkService,
    required JWTService jwtService,
  })  : _authMapper = authMapper,
        _remote = remoteDatasource,
        _local = localDatasource,
        _network = networkService,
        _jwt = jwtService;

  @override
  Future<bool> get isAuthenticated async {
    // Check if a token is available
    final hasToken = await _local.hasToken;

    // Check if a user is available
    final hasUser = await _local.hasUser;

    // Return true only if both token and user are available
    return hasToken && hasUser;
  }

  @override
  Future<bool> get isPartiallyAuthenticated async {
    // Check if a token is available
    final hasToken = await _local.hasToken;

    // Check if a user is available
    final hasUser = await _local.hasUser;

    // Return true only if token is unavailable and user is available
    return !hasToken && hasUser;
  }

  @override
  // TODO: implement isVerified
  Future<bool> get isVerified => throw UnimplementedError();

  @override
  Future<User?> get user async {
    final UserDto? userDto = await _local.getCurrentUser();
    final User? userDomain = _authMapper.userToDomain(userDto);
    return userDomain;
  }

  @override
  Future<UserToken?> get userToken => _local.getCurrentUserToken();

  @override
  Future<Either<AuthException, Unit>> changePassword({
    required IPassword currentPassword,
    required IPassword newPassword,
  }) async {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthException, Unit>> forgotPassword(IEmail email) async {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<Map<String, UserCredentials>?> getAllUserCredentials() async {
    final fromLocal = await _local.getAllUserCredentials();

    if (fromLocal != null) {
      final userCredentialsMap = fromLocal.map((key, value) {
        final userCredentials = _authMapper.userCredentialsToDomain(value)!;
        return MapEntry(key, userCredentials);
      });

      return userCredentialsMap;
    }
    return null;
  }

  @override
  Future<Either<AuthException, Unit>> googleSignIn({bool isRegister = false}) {
    // TODO: implement googleSignIn
    throw UnimplementedError();
  }

  @override
  bool isTokenExpired(String token) => _jwt.isExpired(token);

  @override
  Future<Either<AuthException, Unit>> login({
    required IEmail email,
    required IPassword password,
  }) async {
    final String emailValue = email.get()!;
    final String passwordValue = password.get()!;

    if (!(await _network.isConnected)) {
      return left(const AuthException.networkError());
    }

    try {
      final AuthResponse<UserCredentialsDto> response = await _remote.login(
        email: emailValue,
        password: passwordValue,
      );

      final UserCredentialsDto userCredentialsDto = response.data!;

      await _local.storeAllUserCredentials(userCredentialsDto);
      await _local.storeCurrentToken(userCredentialsDto.token!);
      await _local.storeCurrentUser(userCredentialsDto.user);

      return right(unit);
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 400:
          return left(const AuthException.invalidEmailOrPassword());
        case 500:
          return left(const AuthException.serverError());
        default:
          return left(const AuthException.unknownError());
      }
    } on TimeoutException {
      return left(const AuthException.timeOutError());
    }
  }

  @override
  Future<void> logout() => _local.deleteCurrentUserCredentials();

  @override
  Future<void> partialLogout() => _local.deleteCurrentUserToken();

  @override
  Future<Either<AuthException, Unit>> register({
    required IFullName fullName,
    required IEmail email,
    required IPassword password,
    IBio? bio,
    IAvatar? avatar,
  }) async {
    final String fullNameValue = fullName.get()!;
    final String emailValue = email.get()!;
    final String passwordValue = password.get()!;
    final String? bioValue = bio?.get();
    final File? avatarValue = avatar?.get();

    if (!(await _network.isConnected)) {
      return left(const AuthException.networkError());
    }

    try {
      final AuthResponse<UserCredentialsDto> response = await _remote.register(
        fullName: fullNameValue,
        email: emailValue,
        password: passwordValue,
        bio: bioValue,
        image: avatarValue,
      );

      final UserCredentialsDto userCredentialsDto = response.data!;

      await _local.storeAllUserCredentials(userCredentialsDto);
      await _local.storeCurrentToken(userCredentialsDto.token!);
      await _local.storeCurrentUser(userCredentialsDto.user);

      return right(unit);
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 400:
          return left(const AuthException.emailAlreadyInUse());
        case 500:
          return left(const AuthException.serverError());
        default:
          return left(const AuthException.unknownError());
      }
    } on TimeoutException {
      return left(const AuthException.timeOutError());
    }
  }

  @override
  Future<Either<AuthException, Unit>> requestOtp({
    required IEmail email,
    required String type,
  }) async {
    final String emailValue = email.get()!;

    if (!(await _network.isConnected)) {
      return left(const AuthException.networkError());
    }

    try {
      await _remote.requestOtp(email: emailValue, type: type);

      return right(unit);
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 500:
          return left(const AuthException.serverError());
        default:
          return left(const AuthException.unknownError());
      }
    } on TimeoutException {
      return left(const AuthException.timeOutError());
    }
  }

  @override
  Future<Either<AuthException, Unit>> resetPassword({
    required IEmail email,
    required String code,
    required IPassword newPassword,
  }) async {
    final String emailValue = email.get()!;
    final String newPasswordValue = newPassword.get()!;

    if (!(await _network.isConnected)) {
      return left(const AuthException.networkError());
    }

    try {
      await _remote.resetPassword(
        email: emailValue,
        code: code,
        newPassword: newPasswordValue,
      );

      return right(unit);
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 500:
          return left(const AuthException.serverError());
        default:
          return left(const AuthException.unknownError());
      }
    } on TimeoutException {
      return left(const AuthException.timeOutError());
    }
  }

  @override
  Future<Either<AuthException, Unit>> switchAccount(
    UserCredentials credentials,
  ) async {
    final isExpired = _jwt.isExpired(credentials.token!);
    if (isExpired) {
      return left(const AuthException.userTokenExpired());
    } else {
      final dto = _authMapper.userCredentialsToDto(credentials)!;
      await _local.storeCurrentToken(dto.token!);
      await _local.storeCurrentUser(dto.user);
      return right(unit);
    }
  }

  @override
  Future<Either<AuthException, Unit>> verifyEmailAddress({
    required IEmail email,
    required String code,
  }) async {
    final String emailValue = email.get()!;

    if (!(await _network.isConnected)) {
      return left(const AuthException.networkError());
    }

    try {
      final AuthResponse response = await _remote.verifyEmailAddress(
        email: emailValue,
        code: code,
      );

      if (response.statusCode == 201) {
        return right(unit);
      } else {
        return left(const AuthException.unableToVerifyEmail());
      }
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 500:
          return left(const AuthException.serverError());
        default:
          return left(const AuthException.unknownError());
      }
    } on TimeoutException {
      return left(const AuthException.timeOutError());
    }
  }
}
