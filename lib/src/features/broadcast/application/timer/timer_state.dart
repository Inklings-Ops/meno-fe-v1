part of 'timer_cubit.dart';

@freezed
class TimerState with _$TimerState {
  factory TimerState({
    required String hours,
    required String minutes,
    required String seconds,
    required Duration elapsedTime,
    required bool isRunning,
    String? timeAgo,
  }) = _TimerState;

  factory TimerState.initial() => TimerState(
        hours: '00',
        minutes: '00',
        seconds: '00',
        elapsedTime: Duration.zero,
        isRunning: false,
        timeAgo: null,
      );
}
