import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_fe_v1/features/auth/application/auth/auth_notifier.dart';
import 'package:meno_fe_v1/features/auth/domain/domain.dart';
import 'package:meno_fe_v1/injector/injector.dart';

final facadeProvider = Provider<IAuthFacade>((ref) => di<IAuthFacade>());

final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return di<AuthNotifier>();
});

final credentialsProvider = Provider((ref) {
  return ref.watch(authProvider).allCredentials;
});

final userProvider = Provider((ref) => ref.watch(authProvider).user);

final userTokenProvider = Provider((ref) => ref.watch(authProvider).token);
