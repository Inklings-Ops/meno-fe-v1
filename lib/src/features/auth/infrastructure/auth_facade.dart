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
  AuthFacade({
    required AuthRemoteDatasource remoteDatasource,
    required AuthLocalDatasource localDatasource,
    required NetworkService networkService,
    required JWTService jwtService,
  })  : _remote = remoteDatasource,
        _local = localDatasource,
        _network = networkService,
        _jwt = jwtService;
  final AuthRemoteDatasource _remote;
  final AuthLocalDatasource _local;
  final NetworkService _network;
  final JWTService _jwt;

  final _credentialSubject = BehaviorSubject<UserCredential?>.seeded(null);
  final _tokenSubject = BehaviorSubject<Token?>.seeded(null);

  @override
  @PostConstruct(preResolve: true)
  Future<void> init() async {
    final dto = await _local.getAuthCredential();
    final credential = dto?.toDomain;
    _credentialSubject.add(credential);
    _tokenSubject.add(credential?.token);
  }

  @override
  Future<Map<String, UserCredential>?> get allCredentials async {
    final map = await _local.getAllUserCredentials();
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
    final userDto = await _local.getAuthCredential();
    final userDomain = userDto?.user.toDomain;
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
  bool isTokenValid(String? token) {
    if (token == null) return false;
    return _jwt.isExpired(token);
  }

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

      await _local.storeCredentials(response.data!);

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
  }

  @override
  Future<void> removeAccount(Uid<User> userId) async {
    await _local.deleteAuthCredential();
    await _local.deleteAuthToken();

    if (credential?.user.id == userId) {
      _credentialSubject.add(null);
      _tokenSubject.add(null);
    }
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
      await _local.storeCredentials(response.data!);
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
  Future<Either<AuthException, UserCredential>> switchAccount(
    Uid<User> userId,
  ) async {
    final allCreds = await _local.getAllUserCredentials();
    if (allCreds == null) return left(const NoUserAccountFound());

    final credentialDto = allCreds[userId.getOr()];
    if (credentialDto == null) return left(const NoUserAccountFound());

    final credential = credentialDto.toDomain;

    final token = credential.token;
    if (!(token?.isActive ?? false)) return left(const UserTokenExpired());

    try {
      await _local.storeCredentials(credentialDto);
      _credentialSubject.add(credential);
      _tokenSubject.add(credential.token);

      return right(credential);
    } catch (e) {
      return left(AuthException.message(e.toString()));
    }
  }

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
    // (gettoknowdavid): implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthException, Unit>> forgotPassword(Email email) async {
    // (gettoknowdavid): implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthException, Unit>> googleSignIn({bool isRegister = false}) {
    // (gettoknowdavid): implement googleSignIn
    throw UnimplementedError();
  }
}
