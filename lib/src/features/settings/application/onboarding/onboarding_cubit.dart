import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/settings/settings.dart';


/// A [Cubit] responsible for managing the onboarding state.
@lazySingleton
class OnboardingCubit extends Cubit<OnboardingState> {

  /// Constructs the [OnboardingCubit] with the provided [ISettingsFacade].
  OnboardingCubit({required ISettingsFacade facade})
      : _facade = facade,
        super(OnboardingState.notCompleted) {
    init();
  }
  final ISettingsFacade _facade;

  /// Clears the onboarding cache asynchronously.
  ///
  /// Emits [OnboardingState.notCompleted] after clearing the cache.
  Future<void> clearCache() async {
    return await _facade.clearCache.whenComplete(
      () => emit(OnboardingState.notCompleted),
    );
  }

  /// Marks the onboarding as complete asynchronously.
  ///
  /// Emits [OnboardingState.completed] after completing onboarding.
  Future<void> complete() async {
    return await _facade.completeOnboarding.whenComplete(
      () => emit(OnboardingState.completed),
    );
  }

  /// Initializes the onboarding state based on whether the user has completed onboarding.
  ///
  /// If the user has completed onboarding, it emits [OnboardingState.completed],
  /// otherwise, it emits [OnboardingState.notCompleted].
  void init() {
    if (_facade.isOnboarded) {
      return emit(OnboardingState.completed);
    } else {
      return emit(OnboardingState.notCompleted);
    }
  }
}

/// Enum representing the possible states of onboarding.
enum OnboardingState {
  /// The user has completed the onboarding process.
  completed,

  /// The user has not completed the onboarding process.
  notCompleted,
}
