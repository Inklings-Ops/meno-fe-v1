import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/features/settings/settings.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

@Injectable(as: ISessionContext)
class SessionContext implements ISessionContext {
  SessionContext({
    required IAuthFacade authFacade,
    required ISettingsFacade settingsFacade,
  })  : _authFacade = authFacade,
        _settingsFacade = settingsFacade;
  final IAuthFacade _authFacade;
  final ISettingsFacade _settingsFacade;

  @override
  bool get isOnboarded => _settingsFacade.isOnboarded;

  @override
  Stream<UserCredential?> get userChanges => _authFacade.userChanges;

  @override
  Future<void> logout() => _authFacade.logout();

  @override
  Future<Either<AuthException, Unit>> switchAccount(UserCredential credential) {
    return _authFacade.switchAccount(credential);
  }

  @override
  UserCredential? get credential => _authFacade.credential;

  @override
  Stream<Map<String, UserCredential>> get allAccounts =>
      _authFacade.allAccounts;
}
