part of 'session_bloc.dart';

@freezed
class SessionEvent with _$SessionEvent {
  const factory SessionEvent.started() = SessionStarted;
  const factory SessionEvent.logout() = SessionLogout;
}
