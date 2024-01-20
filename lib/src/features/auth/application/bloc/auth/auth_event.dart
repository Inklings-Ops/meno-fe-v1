part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.logout() = _AuthLogoutRequested;
  const factory AuthEvent.userChanged({User? user}) = _AuthUserChanged;
  const factory AuthEvent.tokenChanged({UserToken? token}) = _AuthTokenChanged;
}
