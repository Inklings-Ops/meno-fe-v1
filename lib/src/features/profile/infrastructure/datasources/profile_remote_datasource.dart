import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/auth/infrastructure/infrastructure.dart';
import 'package:meno_fe_v1/src/features/profile/infrastructure/dtos/profile_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_remote_datasource.g.dart';

/// A remote data source for profile of the user.
@injectable
@RestApi()
abstract class ProfileRemoteDatasource {
  /// Creates a new `ProfileRemoteDatasource` object.
  @factoryMethod
  factory ProfileRemoteDatasource(
    Dio dio, {
    @Named('baseUrl') String baseUrl,
  }) = _ProfileRemoteDatasource;

  @GET('/api/v1/users/{userId}/profile')
  Future<AuthResponse<ProfileDto>> getProfile(@Path('userId') String userId);
}
