part of 'session_bloc.dart';

@freezed
class SessionEvent with _$SessionEvent {
  const factory SessionEvent.started() = SessionStarted;
  const factory SessionEvent.refresh() = SessionRefresh;
  const factory SessionEvent.logout() = SessionLogout;
}
