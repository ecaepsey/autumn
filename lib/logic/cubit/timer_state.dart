// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:equatable/equatable.dart';


class TimerState extends Equatable {
    final int totalSeconds;
    final int remainingSeconds;
    final bool isRunning;
     final TimerMode mode;
  TimerState({
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.isRunning,
     required this.mode
  });

  TimerState copyWith({
    int? totalSeconds,
    int? remainingSeconds,
    bool? isRunning,
      TimerMode? mode,
  }) {
    return TimerState(
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
        mode: mode ?? this.mode,
      
    );
  }

  double get progress => totalSeconds == 0 ? 0 : remainingSeconds / totalSeconds;

  String get mmss {
    final m = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m: $s';
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [totalSeconds, remainingSeconds, isRunning];



 

  



 

 

 
}

enum TimerMode {
  focus,
  break_,
}