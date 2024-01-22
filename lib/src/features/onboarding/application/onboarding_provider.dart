import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../dependency_injector/injector.dart';
import '../infrastructure/onboarding_local_datasource.dart';

final onboardingProvider = Provider((ref) => di<OnboardingLocalDatasource>());
