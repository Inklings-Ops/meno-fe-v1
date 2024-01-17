import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/profile/infrastructure/dtos/profile_dto.dart';

import '../../../services/network_service.dart';
import '../../auth/domain/domain.dart';
import '../../auth/infrastructure/responses/auth_response.dart';
import '../domain/domain.dart';
import 'datasources/profile_local_datasource.dart';
import 'datasources/profile_remote_datasource.dart';
import 'mapper/profile_mapper.dart';

@LazySingleton(as: IProfileFacade)
class ProfileFacade implements IProfileFacade {
  final ProfileMapper _authMapper;
  final ProfileRemoteDatasource _remote;
  final ProfileLocalDatasource _local;
  final NetworkService _network;

  ProfileFacade({
    required ProfileMapper authMapper,
    required ProfileRemoteDatasource remote,
    required ProfileLocalDatasource local,
    required NetworkService network,
  })  : _authMapper = authMapper,
        _remote = remote,
        _local = local,
        _network = network;

  @override
  Future<Either<AuthException, Unit>> editProfile({
    required UserID id,
    IFullName? fullName,
    IBio? bio,
    IAvatar? avatar,
  }) async {
    final String? fullNameValue = fullName?.get()!;
    final String? bioValue = bio?.get();
    final File? avatarValue = avatar?.get();

    if (!(await _network.isConnected)) {
      return left(const AuthException.networkError());
    }

    try {
      final AuthResponse<ProfileDto> response = await _remote.editProfile(
        userId: id,
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
  Future<Either<AuthException, Profile>> getProfile(UserID id) async {
    if (!(await _network.isConnected)) {
      return left(const AuthException.networkError());
    }

    try {
      final AuthResponse<ProfileDto> response = await _remote.getProfile(id);

      await _local.storeProfile(response.data!);

      final Profile? profile = _authMapper.toDomain(response.data);

      return right(profile!);
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
    final result = await _local.getProfile();

    if (!(await _network.isConnected)) {
      final Profile? profile = _authMapper.toDomain(result);
      return right(profile);
    }

    try {
      final response = await _remote.getProfile(result!.id);

      await _local.storeProfile(response.data!);

      final Profile? profile = _authMapper.toDomain(response.data);

      return right(profile);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const AuthException.timeOutError());
    }
  }
}
