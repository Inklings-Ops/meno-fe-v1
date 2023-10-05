import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_fe_v1/features/onboarding/infrastructure/onboarding_local_datasource.dart';
import 'package:meno_fe_v1/injector/injector.dart';

final onboardingProvider = Provider((ref) => di<OnboardingLocalDatasource>());
