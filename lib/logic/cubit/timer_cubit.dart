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

  Future<void> _saveSessionIfNeeded({required bool completed}) async {
    // сохраняем только focus-сессии
    if (state.mode != TimerMode.focus) return;

    final taskId = state.selectedTaskId;
    if (taskId == null) return;

    final elapsed = state.totalSeconds - state.remainingSeconds;

    // чтобы не сохранять случайные клики (например 1–2 секунды)
    if (elapsed <= 0) return; // nothing worked

    await onFocusCompleted(
      FocusSession(
        endedAt: DateTime.now(),
        durationSeconds: elapsed,
        taskId: taskId,
        completed: completed,
      ),
    );
  }

  void start() {
    if (state.isRunning) return;

    emit(state.copyWith(isRunning: true));

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) async {
      final next = state.remainingSeconds - 1;

      if (next <= 0) {
        _ticker?.cancel();

        await _saveSessionIfNeeded(completed: true);

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

  Future<void> next() async {
    _ticker?.cancel();

    // ✅ save partial focus session if any time passed
    await _saveSessionIfNeeded(completed: false);

    final nextMode = state.mode == TimerMode.focus
        ? TimerMode.break_
        : TimerMode.focus;
    final seconds = nextMode == TimerMode.focus ? 25 * 60 : 5 * 60;

    emit(
      state.copyWith(
        mode: nextMode,
        totalSeconds: seconds,
        remainingSeconds: seconds,
        isRunning: false,
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
