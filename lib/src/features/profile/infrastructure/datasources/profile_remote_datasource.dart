import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/auth/infrastructure/infrastructure.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';
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

  @GET('/api/v1/subscribers')
  Future<AuthResponse<SubscribersListDto>> subcribers({
    @Query('subscriberId') String? subscriberId,
    @Query('subscriptionId') String? subscriptionId,
    @Query('include') String? include,
    @Query('keywords') String? keywords,
    @Query('page') int? page,
    @Query('size') int? size,
  });

  @POST('/api/v1/subscribers')
  Future<AuthResponse<dynamic>> subscribe({@Field() required String userId});

  @DELETE('/api/v1/subscribers')
  Future<AuthResponse<dynamic>> unsubscribe({
    @Field('userId') required String userId,
  });
}
