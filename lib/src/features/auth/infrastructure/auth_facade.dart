import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';
import 'package:rxdart/rxdart.dart';

@Injectable(as: IAuthFacade)
class AuthFacade implements IAuthFacade {
  final AuthRemoteDatasource _remote;
  final AuthLocalDatasource _local;
  final NetworkService _network;
  final JWTService _jwt;

  final _credentialSubject = BehaviorSubject<UserCredential?>.seeded(null);
  final _tokenSubject = BehaviorSubject<Token?>.seeded(null);

  AuthFacade({
    required AuthRemoteDatasource remoteDatasource,
    required AuthLocalDatasource localDatasource,
    required NetworkService networkService,
    required JWTService jwtService,
  })  : _remote = remoteDatasource,
        _local = localDatasource,
        _network = networkService,
        _jwt = jwtService;

  @override
  @PostConstruct(preResolve: true)
  Future<void> init() async {
    final dto = await _local.getUserCredential();
    final credential = dto?.toDomain;
    _credentialSubject.add(credential);
    _tokenSubject.add(credential?.token);
  }

  @override
  Future<Map<String, UserCredential>?> get allCredentials async {
    final map = await _local.getAllUserCredentials;
    if (map != null) {
      final userCredentialsMap = map.map((key, value) {
        final userCredentials = value.toDomain;
        return MapEntry(key, userCredentials);
      });

      return userCredentialsMap;
    }
    return null;
  }

  @override
  UserCredential? get credential => _credentialSubject.value;

  @override
  Future<User> get user async {
    final userDto = await _local.getCurrentUser;
    final userDomain = userDto?.toDomain;
    return userDomain ?? User.empty();
  }

  @override
  Stream<UserCredential?> get userChanges {
    return _credentialSubject.stream.asBroadcastStream();
  }

  @override
  Stream<Token?> get tokenChanges => _tokenSubject.stream.asBroadcastStream();

  @override
  Token? get userToken => _tokenSubject.valueOrNull;

  @override
  bool isTokenExpired(String token) => _jwt.isExpired(token);

  @override
  Future<Either<AuthException, UserCredential>> login({
    required Email email,
    required Password password,
  }) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const AuthException.networkError());

    final emailStr = email.value.getOrElse(() => MErrorMessages.invalidEmail);
    final pwdStr = password.value.getOrElse(() => MErrorMessages.invalidPwd);

    try {
      final response = await _remote.login(email: emailStr, password: pwdStr);
      final credential = response.data!.toDomain;
      _credentialSubject.add(credential);
      _tokenSubject.add(credential.token);
      await _local.storeAuthCombined(response.data!);
      return right(credential);
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
  Future<void> logout() async {
    _credentialSubject.add(null);
    _tokenSubject.add(null);
    await _local.deleteCurrentUserCredential();
  }

  @override
  Future<Either<AuthException, UserCredential>> register({
    required SingleLineString fullName,
    required Email email,
    required Password password,
    Bio? bio,
    Avatar? avatar,
  }) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const AuthException.networkError());

    final nameStr = fullName.value.getOrElse(() => MErrorMessages.invalidFName);
    final emailStr = email.value.getOrElse(() => MErrorMessages.invalidEmail);
    final pwdStr = password.value.getOrElse(() => MErrorMessages.invalidPwd);
    final bioStr = bio?.value.getOrElse(() => MErrorMessages.invalidBio);
    final avatarFile = avatar?.value.getOrElse(() => null);

    try {
      final response = await _remote.register(
        fullName: nameStr,
        email: emailStr,
        password: pwdStr,
        bio: bioStr,
        image: avatarFile,
      );
      final credential = response.data!.toDomain;
      _credentialSubject.add(credential);
      _tokenSubject.add(credential.token);
      await _local.storeAuthCombined(response.data!);
      return right(credential);
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
    required Email email,
    required String type,
  }) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const AuthException.networkError());
    final emailStr = email.value.getOrElse(() => MErrorMessages.invalidEmail);
    try {
      await _remote.requestOtp(email: emailStr, type: type);
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
    required Email email,
    required String code,
    required Password newPassword,
  }) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const AuthException.networkError());

    final emailStr = email.value.getOrElse(() => MErrorMessages.invalidEmail);
    final pwdStr = newPassword.value.getOrElse(() => MErrorMessages.invalidPwd);

    try {
      await _remote.resetPassword(
        email: emailStr,
        code: code,
        newPassword: pwdStr,
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
  Future<Either<AuthException, Unit>> switchAccount(UserCredential c) async {
    if (c.token != null && c.token?.isActive == true) {
      _credentialSubject.add(c);
      _tokenSubject.add(c.token);
      await _local.storeAuthCombined(c.toDto);
      return right(unit);
    } else {
      return left(const AuthException.userTokenExpired());
    }
  }
  // @override
  // Future<Either<AuthException, Unit>> switchAccount(
  //   UserCredential credential,
  // ) async {
  //   final isExpired = _jwt.isExpired(credential.token!);
  //   if (isExpired) {
  //     return left(const AuthException.userTokenExpired());
  //   } else {
  //     final dto = credential.toDto;

  //     await _local.storeAuthUserCredentials(dto);

  //     _userController.add(credential);
  //     _tokenController.add(credential.token);

  //     return right(unit);
  //   }
  // }

  @override
  Future<Either<AuthException, Unit>> verifyEmailAddress({
    required Email email,
    required String code,
  }) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const AuthException.networkError());

    final emailStr = email.value.getOrElse(() => MErrorMessages.invalidEmail);
    try {
      final response = await _remote.verifyEmailAddress(
        email: emailStr,
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

  @override
  Future<bool> get isVerified => throw UnimplementedError();

  @override
  Future<Either<AuthException, Unit>> changePassword({
    required Password currentPassword,
    required Password newPassword,
  }) async {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthException, Unit>> forgotPassword(Email email) async {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthException, Unit>> googleSignIn({bool isRegister = false}) {
    // TODO: implement googleSignIn
    throw UnimplementedError();
  }
}
