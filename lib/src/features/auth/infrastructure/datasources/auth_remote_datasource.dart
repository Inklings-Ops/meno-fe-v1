import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../dtos/dtos.dart';
import '../responses/auth_response.dart';

part 'auth_remote_datasource.g.dart';

/// A remote data source for authentication.
@RestApi()
abstract class AuthRemoteDatasource {
  /// Creates a new `AuthRemoteDatasource` object.
  @factoryMethod
  factory AuthRemoteDatasource(Dio dio, {String baseUrl}) =
      _AuthRemoteDatasource;

  @POST('/api/v1/users/password/change')
  Future<AuthResponse> changePassword({
    @Field() required String currentPassword,
    @Field() required String newPassword,
  });

  @POST('/api/v1/users/password/forgot')
  Future<AuthResponse> forgotPassword(@Field() String email);

  /// Signs in the user using Google.
  ///
  /// Returns an `AuthResponse` object, which contains either a `UserCredentialsDto` object or an `AuthError` object.
  @POST('/api/v1/users/signin/google')
  Future<AuthResponse<UserCredentialsDto>> googleLogin(
    @Field() String idToken,
  );

  /// Registers the user using Google.
  ///
  /// Returns an `AuthResponse` object, which contains either a `UserCredentialsDto` object or an `AuthError` object.
  @POST('/api/v1/users/signup/google')
  Future<AuthResponse<UserCredentialsDto>> googleRegister(
    @Field() String idToken,
  );

  /// Signs in the user using their email address and password.
  ///
  /// Returns an `AuthResponse` object, which contains either a `UserCredentialsDto` object or an `AuthError` object.
  @POST('/api/v1/users/signin')
  Future<AuthResponse<UserCredentialsDto>> login({
    @Field() required String email,
    @Field() required String password,
  });

  /// Registers the user.
  ///
  /// Returns an `AuthResponse` object, which contains either a `UserCredentialsDto` object or an `AuthError` object.
  @POST('/api/v1/users/signup')
  @MultiPart()
  Future<AuthResponse<UserCredentialsDto>> register({
    @Part() required String fullName,
    @Part() required String email,
    @Part() required String password,
    @Part() String? bio,
    @Part(name: 'image', contentType: 'image/png') File? image,
  });

  @POST('/api/v1/users/otp')
  Future<AuthResponse> requestOtp({
    @Field() required String email,
    @Field() required String type,
  });

  @POST('/api/v1/users/password/reset')
  Future<AuthResponse> resetPassword({
    @Field() required String email,
    @Field() required String code,
    @Field() required String newPassword,
  });

  @POST('/api/v1/users/email/verify')
  Future<AuthResponse> verifyEmailAddress({
    @Field() required String email,
    @Field() required String code,
  });
}
