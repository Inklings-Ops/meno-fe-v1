import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
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
  UserCredential? get credential => _authFacade.credential;

  @override
  Future<List<UserCredential>> get allCredentials async {
    final credentialsMap = await _authFacade.allCredentials;
    return credentialsMap?.values.toList() ?? [];
  }

  @override
  Stream<UserCredential?> get userChanges => _authFacade.userChanges;

  @override
  Future<void> logout() => _authFacade.logout();

  @override
  Future<Either<AuthException, UserCredential>> switchAccount(
    UserCredential credential,
  ) {
    return _authFacade.switchAccount(credential.user.id);
  }

  @override
  Future<void> refresh() => _authFacade.init();

  @override
  Future<Token?> getCurrentAuthToken() async {
    final credential = _authFacade.credential;
    if (credential != null && (credential.token?.isValid ?? false)) {
      return credential.token!;
    }
    return null;
  }
}
