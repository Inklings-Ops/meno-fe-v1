import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/auth/domain/domain.dart';
import 'package:meno_fe_v1/src/features/profile/domain/domain.dart';
import 'package:meno_fe_v1/src/features/profile/infrastructure/datasources/profile_local_datasource.dart';
import 'package:meno_fe_v1/src/features/profile/infrastructure/datasources/profile_remote_datasource.dart';
import 'package:meno_fe_v1/src/features/profile/infrastructure/dtos/profile_dto.dart';
import 'package:meno_fe_v1/src/services/network_service.dart';

@LazySingleton(as: IProfileFacade)
class ProfileFacade implements IProfileFacade {
  ProfileFacade({
    required ProfileRemoteDatasource remote,
    required ProfileLocalDatasource local,
    required NetworkService network,
  })  : _remote = remote,
        _local = local,
        _network = network;
  final ProfileRemoteDatasource _remote;
  final ProfileLocalDatasource _local;
  final NetworkService _network;

  @override
  Future<Either<AuthException, Profile>> getProfile(UserID id) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const AuthException.networkError());

    try {
      final response = await _remote.getProfile(id);
      return right(response.data!.toDomain);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const AuthException.timeOutError());
    }
  }

  AuthException _getError(DioException e) {
    final errorData = e.response?.data as Map<String, dynamic>;
    final unknownError = errorData['error'] as dynamic;
    if (unknownError.runtimeType == String) {
      return AuthException.message(errorData['message'] as String);
    }

    final message = errorData['error'] as Map<String, dynamic>;
    final error = AuthError.fromJson(message);
    String? result;

    for (final prop in error.props) {
      result ??= prop;
    }

    if (result != null) {
      return AuthException.message(result);
    }

    return const AuthException.serverError();
  }

  @override
  Future<Either<AuthException, Profile?>> getAuthProfile() async {
    final hasLocalProfile = await _local.hasLocalProfile;
    final isConnected = await _network.isConnected;

    if (!isConnected && hasLocalProfile) {
      final dto = await _local.getProfile();
      return right(dto?.toDomain);
    }

    if (!isConnected && !hasLocalProfile) {
      return left(const AuthException.networkError());
    }

    final userId = await _local.getAuthUserId();
    if (userId == null) return left(const AuthException.message('No user'));

    try {
      final response = await _remote.getProfile(userId);
      await _local.storeProfile(response.data!);
      return right(response.data?.toDomain);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const AuthException.timeOutError());
    }
  }
}
