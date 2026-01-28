
import 'dart:async';
import 'package:autumn/logic/cubit/timer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit({int totalSeconds = 25 * 60 })
    : super(TimerState(
      totalSeconds: totalSeconds, 
      remainingSeconds: totalSeconds, 
      isRunning: false,
      mode: TimerMode.focus
  ));

  Timer? _ticker;

  void start() {
    if (state.isRunning) return;

    emit(state.copyWith(isRunning: true));

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = state.remainingSeconds - 1;

      if (next <= 0) {
        _ticker?.cancel();
        emit(state.copyWith(remainingSeconds: 0, isRunning: false));
      } else {
        emit(state.copyWith(remainingSeconds: next));
      }
    });
  }


  void stop() {
    _ticker?.cancel();
    emit(state.copyWith(isRunning: false));
  }

  void reset() {
    _ticker?.cancel();
    emit(state.copyWith(
      remainingSeconds: state.totalSeconds,
     isRunning: false));
  }

  void setDurationMinutes(int minutes) {
    final secs = minutes * 60;
    _ticker?.cancel();
    emit(TimerState(totalSeconds: secs, remainingSeconds: secs, isRunning: false, mode: TimerMode.focus));

  }

  @override
  Future<void> close() {
    // TODO: implement close
    _ticker?.cancel();
    return super.close();
  }

  void changeMode(TimerMode mode) {
    _ticker?.cancel();

    final seconds = switch (mode) {
      TimerMode.focus => 25 * 60,
      TimerMode.break_ => 5 * 60,
    };

    emit(
      TimerState(
        mode: mode,
        totalSeconds: seconds,
        remainingSeconds: seconds,
        isRunning: false,
      ),
    );
  }


  
}

class ToggleCubit extends Cubit<int> {
  ToggleCubit({int initialIndex = 0}) : super(initialIndex);

  void select(int index) => emit(index);
}