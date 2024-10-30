import 'dart:async';

import 'package:bloc/bloc.dart';

class ChatTimerCubit extends Cubit<DateTime> {
  ChatTimerCubit() : super(DateTime.now()) {
    startTimer();
  }
  Timer? _timer;

  void startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      emit(DateTime.now());
    });
  }

  void stop() {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
