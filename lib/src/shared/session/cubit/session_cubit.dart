import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/router/router.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'session_cubit.freezed.dart';
part 'session_state.dart';

@Injectable()
class SessionCubit extends Cubit<SessionState> with ChangeNotifier {
  SessionCubit({required ISessionContext session})
      : _session = session,
        super(const SessionState.loading());
  final ISessionContext _session;
  late final StreamSubscription<UserCredential?> _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    _subscription = _session.userChanges.listen((credential) {
      final sessionState = _determineState(_session.isOnboarded, credential);
      emit(sessionState);
      notifyListeners();
    });
  }

  Future<void> logout() async {
    emit(const SessionState.unauthenticated());
    unawaited(_session.logout());
    notifyListeners();
  }

  SessionState _determineState(bool isOnboarded, UserCredential? credential) {
    if (!_session.isOnboarded) {
      return const SessionState.onboarding();
    } else if (credential == null) {
      return const SessionState.unauthenticated();
    } else if (credential.token == null) {
      return SessionState.partiallyAuthenticated(user: credential.user);
    } else {
      return SessionState.authenticated(
        user: credential.user,
        token: credential.token!,
      );
    }
  }
}
