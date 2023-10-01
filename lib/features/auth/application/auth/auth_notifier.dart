import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_fe_v1/features/auth/domain/domain.dart';
import 'package:meno_fe_v1/features/auth/infrastructure/datasources/auth_local_datasource.dart';
import 'package:meno_fe_v1/injector/injector.dart';
import 'package:meno_fe_v1/services/secure_storage_service.dart';

part 'auth_notifier.freezed.dart';
part 'auth_state.dart';

final authFacadeProvider = Provider((ref) => di<IAuthFacade>());

final authLocalDatasourceProvider = Provider(
  (ref) => AuthLocalDatasource(storage: SecureStorageService()),
);

final isLoggedInProvided = FutureProvider<bool>((ref) async {
  return await ref.watch(authFacadeProvider).isLoggedIn;
});

class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthFacade _authFacade;

  AuthNotifier(this._authFacade) : super(const AuthState.initial());

  Future<void> checkAuthenticated() async {}
}
