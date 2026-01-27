
import 'dart:async';
import 'package:autumn/logic/cubit/timer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit({int totalSeconds = 25 * 60 })
  :super(TimerState(totalSeconds: totalSeconds, 
  remainingSeconds: totalSeconds, 
  isRunning: totalSeconds
  ));

  
}