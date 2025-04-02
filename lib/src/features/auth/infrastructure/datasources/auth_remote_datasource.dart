import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/auth/infrastructure/dtos/dtos.dart';
import 'package:meno_fe_v1/src/features/auth/infrastructure/responses/auth_response.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_remote_datasource.g.dart';

/// A remote data source for authentication.
@injectable
@RestApi()
abstract class AuthRemoteDatasource {
  /// Creates a new `AuthRemoteDatasource` object.
  @factoryMethod
  factory AuthRemoteDatasource(
    Dio dio, {
    @Named('baseUrl') String baseUrl,
  }) = _AuthRemoteDatasource;

  @POST('/api/v1/users/password/change')
  Future<AuthResponse<UserCredentialDto>> changePassword({
    @Field() required String currentPassword,
    @Field() required String newPassword,
  });

  @POST('/api/v1/users/password/forgot')
  Future<AuthResponse<UserCredentialDto>> forgotPassword(@Field() String email);

  /// Signs in the user using Google.
  ///
  /// Returns an `AuthResponse` object, which contains either a
  /// `UserCredentialsDto` object or an `AuthError` object.
  @POST('/api/v1/users/signin/google')
  Future<AuthResponse<UserCredentialDto>> googleLogin(
    @Field() String idToken,
  );

  /// Registers the user using Google.
  ///
  /// Returns an `AuthResponse` object, which contains either a
  /// `UserCredentialsDto` object or an `AuthError` object.
  @POST('/api/v1/users/signup/google')
  Future<AuthResponse<UserCredentialDto>> googleRegister(
    @Field() String idToken,
  );

  /// Signs in the user using their email address and password.
  ///
  /// Returns an `AuthResponse` object, which contains either a
  /// `UserCredentialsDto` object or an `AuthError` object.
  @POST('/api/v1/users/signin')
  Future<AuthResponse<UserCredentialDto>> login({
    @Field() required String email,
    @Field() required String password,
  });

  /// Registers the user.
  ///
  /// Returns an `AuthResponse` object, which contains either a
  /// `UserCredentialsDto` object or an `AuthError` object.
  @POST('/api/v1/users/signup')
  @MultiPart()
  Future<AuthResponse<UserCredentialDto>> register({
    @Part() required String fullName,
    @Part() required String email,
    @Part() required String password,
    @Part() String? bio,
    @Part(name: 'image', contentType: 'image/png') File? image,
  });

  @POST('/api/v1/users/otp')
  Future<AuthResponse<UserCredentialDto>> requestOtp({
    @Field() required String email,
    @Field() required String type,
  });

  @POST('/api/v1/users/password/reset')
  Future<AuthResponse<UserCredentialDto>> resetPassword({
    @Field() required String email,
    @Field() required String code,
    @Field() required String newPassword,
  });

  @POST('/api/v1/users/email/verify')
  Future<AuthResponse<UserCredentialDto>> verifyEmailAddress({
    @Field() required String email,
    @Field() required String code,
  });

  @PUT('/api/v1/users/{userId}/profile')
  @MultiPart()
  Future<AuthResponse<UserDto>> editProfile({
    @Path('userId') required String userId,
    @Part() String? fullName,
    @Part() String? bio,
    @Part(name: 'image', contentType: 'image/png') File? image,
  });

  @GET('/api/v1/users/profiles')
  Future<AuthResponse<ProfilesListDto>> getProfiles({
    @Query('userId') String? userId,
    @Query('include') String? include,
    @Query('keywords') String? keywords,
    @Query('sortBy') String? sortBy,
    @Query('orderBy') String? orderBy,
    @Query('page') int? page,
    @Query('size') int? size,
  });
}
