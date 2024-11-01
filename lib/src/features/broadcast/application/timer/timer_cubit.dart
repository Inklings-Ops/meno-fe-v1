import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/shared/helpers/date_helpers.dart';

part 'timer_cubit.freezed.dart';
part 'timer_state.dart';

@lazySingleton
class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(TimerState.initial());
  Timer? _timer;

  Future<void> dispose() async => reset();

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    emit(TimerState.initial());
  }

  void setAndStart([DateTime? startTime]) {
    set(startTime);
    start();
  }

  void set([DateTime? startTime]) {
    if (startTime == null) return;

    final duration = DateTime.now().difference(startTime).abs();
    emit(
      state.copyWith(
        elapsedTime: duration,
        hours: _calculateTime(duration, _Unit.hrs),
        minutes: _calculateTime(duration, _Unit.mins),
        seconds: _calculateTime(duration, _Unit.secs),
        timeAgo: DateHelpers.getTimeAgo(duration),
      ),
    );
  }

  void start() {
    if (_timer != null) {
      return;
    }
    _timer ??= Timer.periodic(const Duration(milliseconds: 100), (timer) {
      emit(
        state.copyWith(
          isRunning: timer.isActive,
          elapsedTime: state.elapsedTime + const Duration(milliseconds: 100),
          hours: _calculateTime(state.elapsedTime, _Unit.hrs),
          minutes: _calculateTime(state.elapsedTime, _Unit.mins),
          seconds: _calculateTime(state.elapsedTime, _Unit.secs),
          timeAgo: DateHelpers.getTimeAgo(state.elapsedTime),
        ),
      );
    });
  }

  void stop() {
    _timer?.cancel();
    emit(state.copyWith(isRunning: false));
  }

  String _calculateTime(Duration time, _Unit unit) {
    return switch (unit) {
      _Unit.hrs => time.inHours.toString().padLeft(2, '0'),
      _Unit.mins => time.inMinutes.remainder(60).toString().padLeft(2, '0'),
      _Unit.secs => time.inSeconds.remainder(60).toString().padLeft(2, '0'),
    };
  }
}

enum _Unit { hrs, mins, secs }
