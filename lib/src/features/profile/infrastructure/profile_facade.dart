import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/src/features/profile/infrastructure/dtos/profile_dto.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

import '../../../services/network_service.dart';
import '../../auth/domain/domain.dart';
import '../domain/domain.dart';
import 'datasources/profile_local_datasource.dart';
import 'datasources/profile_remote_datasource.dart';

@LazySingleton(as: IProfileFacade)
class ProfileFacade implements IProfileFacade {
  final ProfileRemoteDatasource _remote;
  final ProfileLocalDatasource _local;
  final NetworkService _network;

  ProfileFacade({
    required ProfileRemoteDatasource remote,
    required ProfileLocalDatasource local,
    required NetworkService network,
  })  : _remote = remote,
        _local = local,
        _network = network;

  @override
  Future<Either<AuthException, Unit>> editProfile({
    SingleLineString? fullName,
    Bio? bio,
    Avatar? avatar,
  }) async {
    final fullNameValue = fullName?.getOr();
    final bioValue = bio?.getOr();
    final avatarValue = avatar?.getOr();

    final (credentials, hasNetwork) = await (
      _local.getUserCredential(),
      _network.isConnected,
    ).wait;

    if (hasNetwork) return left(const AuthException.networkError());

    try {
      final response = await _remote.editProfile(
        userId: credentials!.user.id,
        fullName: fullNameValue,
        bio: bioValue,
        image: avatarValue,
      );

      await _local.storeProfile(response.data!);

      return right(unit);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const AuthException.timeOutError());
    }
  }

  @override
  Future<Either<AuthException, Profile?>> getProfile(UserID id) async {
    if (!(await _network.isConnected)) {
      return left(const AuthException.networkError());
    }

    try {
      final response = await _remote.getProfile(id);
      Logger().e(response);
      return right(response.data?.toDomain);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const AuthException.timeOutError());
    }
  }

  AuthException _getError(DioException e) {
    if (e.response?.data['error'].runtimeType == String) {
      return AuthException.message(e.response?.data['message']);
    }

    final error = AuthError.fromJson(e.response!.data['error']);
    String? result;

    for (String? prop in error.props) {
      result ??= prop;
    }

    if (result != null) {
      return AuthException.message(result);
    }

    return const AuthException.serverError();
  }

  @override
  Future<Either<AuthException, Profile?>> getAuthProfile() async {
    final (credentials, hasNetwork, hasProfile) = await (
      _local.getUserCredential(),
      _network.isConnected,
      _local.hasLocalProfile,
    ).wait;

    if (!hasNetwork && !hasProfile) {
      Logger().w('DOING NOTHING');
      return left(const AuthException.networkError());
    }

    if (!hasNetwork && hasProfile) {
      Logger().w('DOING LOCAL');
      final dto = await _local.getProfile();
      return right(dto?.toDomain);
    }

    try {
      Logger().w('DOING REMOTE');
      final response = await _remote.getProfile(credentials!.user.id);

      return right(response.data?.toDomain);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const AuthException.timeOutError());
    }
  }
}
