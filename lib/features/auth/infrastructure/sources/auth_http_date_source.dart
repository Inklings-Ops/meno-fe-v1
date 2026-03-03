import 'package:dio/dio.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/auth/infrastructure/infrastructure.dart';

final class AuthHttpDataSource {
  const AuthHttpDataSource(this._client);

  final ApiClient _client;

  /// Login with email and password.
  Future<UserCredentialDto> login({
    required String email,
    required String password,
    String? pushNotificationToken,
  }) {
    return _client.post(
      '/users/signin',
      data: {
        'email': email,
        'password': password,
        'pushNotificationToken': pushNotificationToken,
      },
      fromJson: UserCredentialDto.fromJson,
    );
  }

  /// Register a new user account.
  Future<UserCredentialDto> register({
    required String fullName,
    required String email,
    required String password,
    String? pushNotificationToken,
  }) {
    return _client.post(
      '/users/signup',
      data: {
        'fullName': fullName,
        'email': email,
        'password': password,
        'pushNotificationToken': pushNotificationToken,
      },
      fromJson: UserCredentialDto.fromJson,
    );
  }

  // #########################################################################
  // GOOGLE AUTH
  // #########################################################################

  Future<UserCredentialDto> googleSignIn({
    required String idToken,
    String? pushNotificationToken,
  }) {
    return _client.post(
      '/users/signin/google',
      data: {
        'idToken': idToken,
        'pushNotificationToken': pushNotificationToken,
      },
      fromJson: UserCredentialDto.fromJson,
    );
  }

  Future<UserCredentialDto> googleSignUp({
    required String idToken,
    String? pushNotificationToken,
  }) {
    return _client.post(
      '/users/signup/google',
      data: {
        'idToken': idToken,
        'pushNotificationToken': pushNotificationToken,
      },
      fromJson: UserCredentialDto.fromJson,
    );
  }

  // #########################################################################
  // EMAIL VERIFICATION
  // #########################################################################

  Future<void> verifyEmail({required String email, required String code}) {
    return _client.postUnit(
      '/users/email/verify',
      data: {'email': email, 'code': code},
    );
  }

  // #########################################################################
  // PASSWORD RECOVERY
  // #########################################################################

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return _client.postUnit(
      '/users/password/change',
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
  }

  Future<void> forgotPassword(String email) {
    return _client.postUnit('/users/password/forgot', data: {'email': email});
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) {
    return _client.postUnit(
      '/users/password/reset',
      data: {'email': email, 'code': code, 'newPassword': newPassword},
    );
  }

  // #########################################################################
  // OTP
  // #########################################################################

  Future<void> requestOtp({required String email, required String type}) {
    return _client.postUnit('/users/otp', data: {'email': email, 'type': type});
  }

  // #########################################################################
  // DELETE USER
  // #########################################################################
  Future<void> deleteUser([CancelToken? cancelToken]) {
    return _client.deleteUnit('/users', cancelToken: cancelToken);
  }
}
