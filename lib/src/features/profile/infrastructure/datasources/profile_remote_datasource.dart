import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/core/core.dart';
import 'package:meno_fe_v1/src/features/auth/infrastructure/infrastructure.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';
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

  @PUT('/api/v1/users/{userId}/profile')
  @MultiPart()
  Future<BaseResponse<UserDto>> editProfile({
    @Path('userId') required String id,
    @Part() String? fullName,
    @Part() String? bio,
    @Part(name: 'image', contentType: 'image/png') File? image,
  });

  @GET('/api/v1/users/{userId}/profile')
  Future<BaseResponse<ProfileDto>> getProfile(@Path('userId') String id);

  @GET('/api/v1/users/profiles')
  Future<BaseResponse<PaginatedProfileResponse<ProfileDto?>>> getProfiles({
    @Query('keywords') String? keywords,
    @Query('include') String? include,
    @Query('sortBy') String? sortBy,
    @Query('orderBy') OrderBy? orderBy,
    @Query('page') int? page,
    @Query('size') int? size,
  });

  @GET('/api/v1/subscribers')
  Future<BaseResponse<PaginatedProfileResponse<ProfileDto?>>> subscribers({
    @Query('subscriberId') String? subscriberId,
    @Query('subscriptionId') String? subscriptionId,
    @Query('keywords') String? keywords,
    @Query('include') String? include,
    @Query('page') int? page,
    @Query('size') int? size,
  });

  @POST('/api/v1/subscribers')
  Future<BaseResponse<dynamic>> subscribe(@Field('userId') String id);

  @DELETE('/api/v1/subscribers')
  Future<BaseResponse<dynamic>> unsubscribe(@Field('userId') String id);
}
