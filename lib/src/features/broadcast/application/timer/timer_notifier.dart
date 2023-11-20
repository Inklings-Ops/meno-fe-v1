import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/shared/helpers/date_helpers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer_notifier.freezed.dart';
part 'timer_notifier.g.dart';
part 'timer_state.dart';

@riverpod
class TimerNotifier extends _$TimerNotifier {
  Timer? _timer;

  @override
  TimerState build() {
    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
    });

    return TimerState.initial();
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    state = TimerState.initial();
  }

  void start() {
    if (_timer != null) {
      return;
    }

    _timer ??= Timer.periodic(const Duration(milliseconds: 100), (timer) {
      state = state.copyWith(
        isRunning: timer.isActive,
        elapsedTime: state.elapsedTime + const Duration(milliseconds: 100),
        hours: _calculateTime(state.elapsedTime, _Unit.hrs),
        minutes: _calculateTime(state.elapsedTime, _Unit.mins),
        seconds: _calculateTime(state.elapsedTime, _Unit.secs),
        timeAgo: DateHelpers.getTimeAgo(state.elapsedTime),
      );
    });
  }

  void stop() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
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
