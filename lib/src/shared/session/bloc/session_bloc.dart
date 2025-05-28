import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/router/router.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'session_event.dart';
part 'session_state.dart';

@Injectable()
class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc({required ISessionContext session})
      : _session = session,
        super(const SessionLoadInProgress()) {
    on<SessionStarted>(_onStarted);
    on<SessionLogoutRequested>(_onLogout);
  }

  final ISessionContext _session;

  ValueNotifier<SessionState> get authState => _authState;
  final _authState = ValueNotifier<SessionState>(const SessionLoadInProgress());

  @override
  void onChange(Change<SessionState> change) {
    super.onChange(change);
    _authState.value = change.nextState;
  }

  @PostConstruct(preResolve: true)
  Future<void> init() async => add(const SessionStarted());

  Future<void> _onStarted(
    SessionStarted event,
    Emitter<SessionState> emit,
  ) async {
    await emit.forEach(
      _session.userChanges,
      onData: (credential) => _determineState(_session.isOnboarded, credential),
      onError: (error, stackTrace) {
        // Handle errors appropriately, perhaps emit an error state.
        debugPrint('Error in SessionBloc stream: $error, $stackTrace');
        return const SessionUnauthenticated();
      },
    );
  }

  void _onLogout(
    SessionLogoutRequested event,
    Emitter<SessionState> emit,
  ) {
    unawaited(_session.logout());
  }

  SessionState _determineState(bool isOnboarded, UserCredential? credential) {
    if (!isOnboarded) return const SessionOnboarding();
    return switch (credential) {
      final UserCredential c when !c.token.isValid =>
        SessionPartiallyAuthenticated(c.user),
      final UserCredential c => SessionAuthenticated(c.user, c.token),
      null => const SessionUnauthenticated(),
    };
  }
}
