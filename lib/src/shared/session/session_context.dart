import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/features/onboarding/onboarding.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';
import 'package:rxdart/rxdart.dart';

import 'session.dart';

@Injectable(as: ISessionContext)
class SessionContext implements ISessionContext {
  final IAuthFacade _authFacade;
  final IOnboardingFacade _onboardingFacade;
  final _sessionSubject = BehaviorSubject.seeded(SessionStatus.loading);
  SessionContext({
    required IAuthFacade authFacade,
    required IOnboardingFacade onboardingFacade,
  })  : _authFacade = authFacade,
        _onboardingFacade = onboardingFacade;

  @override
  bool get isOnboarded => _onboardingFacade.isOnboarded;

  @override
  UserCredential? get credential => _authFacade.credential;

  @override
  Future<List<UserCredential>> get allCredentials async {
    final credentialsMap = await _authFacade.allCredentials;
    return credentialsMap?.values.toList() ?? [];
  }

  @override
  Stream<UserCredential?> get userChanges => _authFacade.userChanges;

  @override
  @PostConstruct(preResolve: true)
  Future<void> init() async {
    final initialCredential = _authFacade.credential;
    final isOnboarded = _onboardingFacade.isOnboarded;
    _sessionSubject.add(_determineStatus(isOnboarded, initialCredential));
    _authFacade.userChanges.listen((credential) {
      final isOnboarded = _onboardingFacade.isOnboarded;
      _sessionSubject.add(_determineStatus(isOnboarded, credential));
    });
  }

  @override
  Future<void> logout() => _authFacade.logout();

  @override
  Future<Either<AuthException, Unit>> switchAccount(UserCredential credential) {
    return _authFacade.switchAccount(credential);
  }
}

SessionStatus _determineStatus(bool isOnboarded, UserCredential? credential) {
  if (!isOnboarded) {
    return SessionStatus.onboarding;
  } else if (credential == null) {
    return SessionStatus.unauthenticated;
  } else if (credential.token == null) {
    return SessionStatus.partiallyAuthenticated;
  } else {
    return SessionStatus.authenticated;
  }
}

  // Stream<SessionStatus> get statusChanges async* {
  //   final isOnboarded = _onboardingFacade.isOnboarded;
  //   final credential = await _authFacade.credential;
  //   yield _determineStatus(isOnboarded, credential);
  //   yield* _authFacade.userChanges.map((credential) {
  //     return _determineStatus(isOnboarded, credential);
  //   }).distinct();
  // }