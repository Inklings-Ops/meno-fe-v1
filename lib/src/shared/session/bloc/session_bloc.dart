import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/router/router.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'session_event.dart';
part 'session_state.dart';
part 'session_bloc.freezed.dart';

@Injectable()
class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc({required ISessionContext session})
      : _session = session,
        super(const SessionLoading()) {
    on<SessionStarted>(_onStarted);
    on<SessionLogout>(_onLogout);
  }

  final ISessionContext _session;

  ValueNotifier<SessionState> get authState => _authState;
  final _authState = ValueNotifier<SessionState>(const SessionLoading());

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
    return emit.forEach(
      _session.userChanges,
      onData: (credential) {
        final sessionState = _determineState(_session.isOnboarded, credential);
        return sessionState;
      },
      onError: (error, stackTrace) {
        // Handle errors appropriately, perhaps emit an error state.
        debugPrint('Error in SessionBloc stream: $error, $stackTrace');
        return const SessionState.unauthenticated();
      },
    );
  }

  void _onLogout(SessionLogout event, Emitter<SessionState> emit) {
    unawaited(_session.logout());
  }

  SessionState _determineState(bool isOnboarded, UserCredential? credential) {
    if (!isOnboarded) return const SessionOnboarding();
    return switch (credential) {
      final UserCredential c when c.token == null || !c.token!.isValid =>
        SessionPartiallyAuthenticated(user: c.user),
      final UserCredential c =>
        SessionAuthenticated(user: c.user, token: c.token!),
      null => const SessionUnauthenticated(),
    };
  }
}
