import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../domain/i_onboarding_facade.dart';

/// A [Cubit] responsible for managing the onboarding state.
@lazySingleton
class OnboardingCubit extends Cubit<OnboardingState> {
  final IOnboardingFacade _facade;

  /// Constructs the [OnboardingCubit] with the provided [IOnboardingFacade].
  OnboardingCubit({required IOnboardingFacade facade})
      : _facade = facade,
        super(OnboardingState.notCompleted);

  /// Clears the onboarding cache asynchronously.
  ///
  /// Emits [OnboardingState.notCompleted] after clearing the cache.
  Future<void> clearCache() async {
    await _facade.clearCache.whenComplete(
      () => emit(OnboardingState.notCompleted),
    );
  }

  /// Marks the onboarding as complete asynchronously.
  ///
  /// Emits [OnboardingState.completed] after completing onboarding.
  Future<void> complete() async {
    await _facade.completeOnboarding.whenComplete(
      () => emit(OnboardingState.completed),
    );
  }

  /// Initializes the onboarding state based on whether the user has completed onboarding.
  ///
  /// If the user has completed onboarding, it emits [OnboardingState.completed],
  /// otherwise, it emits [OnboardingState.notCompleted].
  void init() {
    if (_facade.isOnboarded) {
      emit(OnboardingState.completed);
    } else {
      emit(OnboardingState.notCompleted);
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
