import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/core/exceptions/auth_exception.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

@Injectable(as: IAuthFacade)
class AuthFacade implements IAuthFacade {
  AuthFacade({
    required AuthRemoteDatasource remoteDatasource,
    required AuthLocalDatasource localDatasource,
    required NetworkService networkService,
  })  : _remote = remoteDatasource,
        _local = localDatasource,
        _network = networkService;

  final AuthRemoteDatasource _remote;
  final AuthLocalDatasource _local;
  final NetworkService _network;

  @override
  Stream<Map<String, UserCredential>> get allAccounts {
    return _local.allAccountsStream.map((dtoMap) {
      final domainMap = <String, UserCredential>{};
      dtoMap.forEach((key, dto) => domainMap[key] = dto.toDomain);
      return domainMap;
    });
  }

  @override
  UserCredential? get credential => _local.currentAccount?.toDomain;

  @override
  Future<bool> get isVerified => throw UnimplementedError();

  @override
  Stream<UserCredential?> get userChanges {
    return _local.authStateChanges.map((e) => e?.toDomain);
  }

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

  @override
  Future<Either<AuthException, UserCredential>> login({
    required Email email,
    required Password password,
  }) async {
    try {
      final response = await _remote.login(
        email: email.getOrCrash(),
        password: password.getOrCrash(),
      );
      final credential = response.data!.toDomain;
      await _local.addAccount(response.data!);
      return right(credential);
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 400:
          return left(const InvalidEmailOrPasswordException());
        case 500:
          return left(const AuthServerException());
        default:
          return left(const AuthUnknownException());
      }
    } on TimeoutException {
      return left(const AuthTimeoutException());
    }
  }

  @override
  Future<void> logout() => _local.logout();

  @override
  Future<Either<AuthException, UserCredential>> register({
    required SingleLineString fullName,
    required Email email,
    required Password password,
    MultiLineString? bio,
    ImageFile? avatar,
  }) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const AuthNetworkException());

    final nameStr = fullName.getOrCrash();
    final emailStr = email.getOrCrash();
    final pwdStr = password.getOrCrash();
    final bioStr = bio?.getOrNull();
    final avatarFile = avatar?.getOrNull();

    try {
      final response = await _remote.register(
        fullName: nameStr,
        email: emailStr,
        password: pwdStr,
        bio: bioStr,
        image: avatarFile,
      );
      final credential = response.data!.toDomain;
      await _local.addAccount(response.data!);
      return right(credential);
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 400:
          return left(const EmailAlreadyInUseException());
        case 500:
          return left(const AuthServerException());
        default:
          return left(const AuthUnknownException());
      }
    } on TimeoutException {
      return left(const AuthTimeoutException());
    }
  }

  @override
  Future<void> removeAccount(ID id) => _local.removeAccount(id.getOrCrash());

  @override
  Future<Either<AuthException, Unit>> requestOtp({
    required Email email,
    required String type,
  }) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const AuthNetworkException());
    final emailStr = email.getOrCrash();
    try {
      await _remote.requestOtp(email: emailStr, type: type);
      return right(unit);
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 500:
          return left(const AuthServerException());
        default:
          return left(const AuthUnknownException());
      }
    } on TimeoutException {
      return left(const AuthTimeoutException());
    }
  }

  @override
  Future<Either<AuthException, Unit>> resetPassword({
    required Email email,
    required String code,
    required Password newPassword,
  }) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const AuthNetworkException());

    final emailStr = email.getOrCrash();
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
          return left(const AuthServerException());
        default:
          return left(const AuthUnknownException());
      }
    } on TimeoutException {
      return left(const AuthTimeoutException());
    }
  }

  @override
  Future<Either<AuthException, Unit>> switchAccount(
    UserCredential credential,
  ) async {
    if (!credential.token.isValid) return left(const TokenExpiredException());

    try {
      await _local.switchAccount(credential.toDto);
      return right(unit);
    } on Exception catch (e) {
      return left(AuthExceptionWithMessage(e.toString()));
    }
  }

  @override
  Future<Either<AuthException, Unit>> verifyEmailAddress({
    required Email email,
    required String code,
  }) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const AuthNetworkException());

    final emailStr = email.getOrCrash();
    try {
      final response = await _remote.verifyEmailAddress(
        email: emailStr,
        code: code,
      );
      if (response.statusCode == 201) {
        return right(unit);
      } else {
        return left(const UnableToVerifyEmailException());
      }
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 500:
          return left(const AuthServerException());
        default:
          return left(const AuthUnknownException());
      }
    } on TimeoutException {
      return left(const AuthTimeoutException());
    }
  }
}
