part of 'auth_notifier.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.loggedIn(UserCredentials credentials) = _LoggedIn;
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loggedOut() = _LoggedOut;
  const factory AuthState.partiallyLoggedOut() = _PartiallyLoggedOut;
  const factory AuthState.unverified() = _Unverified;
  const factory AuthState.verified() = _Verified;
}


