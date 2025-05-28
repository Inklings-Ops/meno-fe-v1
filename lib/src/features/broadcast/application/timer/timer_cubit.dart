import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(const TimerState());
  Timer? _timer;

  @override
  Future<void> close() {
    _timer?.cancel();
    log('TimerCubit closed, timer cancelled.');
    return super.close();
  }

  /// Sets the initial elapsed time based on a start time and starts the timer.
  void setAndStart([DateTime? startTime]) {
    _setElapsedTime(startTime);
    start();
  }

  /// Sets the initial elapsed time based on a start time, but doesn't start it.
  void setInitialTime([DateTime? startTime]) {
    _setElapsedTime(startTime);
  }

  /// Starts the timer.
  /// If already running, this does nothing.
  void start() {
    if (_timer?.isActive ?? false) return; // Timer already running

    // Ensure isRunning is true immediately, even before the first tick
    emit(state.copyWith(isRunning: true));

    _timer?.cancel(); // Cancel any existing timer just in case
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // Update state on each tick
      final newElapsed = state.elapsed + const Duration(seconds: 1);
      emit(state.copyWith(elapsed: newElapsed, isRunning: true));
    });
  }

  /// Stops the timer.
  void stop() {
    _timer?.cancel();
    _timer = null;
    // Update state to reflect stopped status
    emit(state.copyWith(isRunning: false));
  }

  /// Stops the timer and resets the elapsed time to zero.
  void reset() {
    _timer?.cancel();
    _timer = null;
    // Reset state to initial values
    emit(const TimerState());
  }

  /// Calculates and sets the elapsed time based on an optional start time.
  void _setElapsedTime([DateTime? startTime]) {
    if (startTime == null) return;
    final now = DateTime.now();
    // Ensure startTime is not in the future, or handle as needed
    final duration = now.difference(startTime).abs();
    // Update only the elapsed part, keep isRunning as it was
    emit(state.copyWith(elapsed: duration));
  }
}
