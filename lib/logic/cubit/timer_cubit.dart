import 'dart:async';
import 'package:autumn/logic/cubit/focus_session.dart';
import 'package:autumn/logic/cubit/timer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit({required this.onFocusCompleted})
    : super(
        TimerState(
          mode: TimerMode.focus,
          totalSeconds: 25 * 60,
          remainingSeconds: 25 * 60,
          isRunning: false,
        ),
      );

  final Future<void> Function(FocusSession session) onFocusCompleted;

  Timer? _ticker;

void selectTask(String taskId) {
  emit(state.copyWith(selectedTaskId: taskId));
}


  void start() {
    if (state.isRunning) return;

    emit(state.copyWith(isRunning: true));

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) async {
      final next = state.remainingSeconds - 1;

      if (next <= 0) {
        _ticker?.cancel();

        if (state.mode == TimerMode.focus) {
          final taskId = state.selectedTaskId;
          if (taskId != null) {
            await onFocusCompleted(
              FocusSession(
                endedAt: DateTime.now(),
                durationSeconds: state.totalSeconds,
                taskId: taskId, 
              ),
            );
          }
        }

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
    emit(
      state.copyWith(remainingSeconds: state.totalSeconds, isRunning: false),
    );
  }

  void setDurationMinutes(int minutes) {
    final secs = minutes * 60;
    _ticker?.cancel();
    emit(
      TimerState(
        totalSeconds: secs,
        remainingSeconds: secs,
        isRunning: false,
        mode: TimerMode.focus,
      ),
    );
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
