part of 'session_bloc.dart';


sealed class SessionEvent with EquatableMixin {
  const SessionEvent();

  @override
  List<Object?> get props => [];

}

final class SessionStarted extends SessionEvent {
  const SessionStarted();
}

final class SessionLogoutRequested extends SessionEvent {
  const SessionLogoutRequested();
}
