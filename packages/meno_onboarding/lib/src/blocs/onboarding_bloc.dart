import 'package:disco/disco.dart';
import 'package:meno_domain/meno_domain.dart';
import 'package:meno_services/meno_services.dart';

final class OnboardingBloc {
  const OnboardingBloc({required LocalStorage storage}) : _storage = storage;
  final LocalStorage _storage;

  static final provider = Provider<OnboardingBloc>(
    (context) => OnboardingBloc(storage: LocalStorageImpl.provider.of(context)),
  );

  Future<void> completeOnboarding() async {
    try {
      await _storage.write('onboarding', value: '1');
    } on Exception {
      rethrow;
    }
  }

  bool isOnboardingComplete() => _storage.hasKey('onboarding');
}
