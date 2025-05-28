part of 'timer_cubit.dart';

class TimerState with EquatableMixin {
  const TimerState({this.elapsed = Duration.zero, this.isRunning = false});
  final Duration elapsed;
  final bool isRunning;

  @override
  List<Object?> get props => [elapsed, isRunning];

  TimerState copyWith({
    Duration? elapsed,
    bool? isRunning,
  }) {
    return TimerState(
      elapsed: elapsed ?? this.elapsed,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
