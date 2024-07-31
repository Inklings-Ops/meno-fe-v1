import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/features/settings/settings.dart';
import 'package:meno_fe_v1/src/shared/session/session.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';
import 'package:rxdart/rxdart.dart';

@Injectable(as: ISessionContext)
class SessionContext implements ISessionContext {
  SessionContext({
    required IAuthFacade authFacade,
    required ISettingsFacade settingsFacade,
  })  : _authFacade = authFacade,
        _settingsFacade = settingsFacade {
    _authFacade.userChanges.listen((credential) {
      final isOnboarded = _settingsFacade.isOnboarded;
      _sessionSubject.add(_determineStatus(isOnboarded, credential));
    });
  }
  final IAuthFacade _authFacade;
  final ISettingsFacade _settingsFacade;
  final _sessionSubject = BehaviorSubject.seeded(SessionStatus.loading);

  @override
  bool get isOnboarded => _settingsFacade.isOnboarded;

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
  @PostConstruct()
  void init() {
    final initialCredential = _authFacade.credential;
    final isOnboarded = _settingsFacade.isOnboarded;
    _sessionSubject.add(_determineStatus(isOnboarded, initialCredential));
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
