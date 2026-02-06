class FocusSession {
  final DateTime endedAt;
  final int durationSeconds;
  final String taskId;
  final bool completed;

  const FocusSession({
    required this.endedAt,
    required this.durationSeconds,
    required this.taskId,
    required this.completed,
  });

  Map<String, dynamic> toMap() => {
        'endedAt': endedAt.toIso8601String(),
        'durationSeconds': durationSeconds,
        'taskId': taskId,
        'completed': completed,
      };

  static FocusSession fromMap(Map map) => FocusSession(
        endedAt: DateTime.parse(map['endedAt'] as String),
        durationSeconds: map['durationSeconds'] as int,
        taskId: map['taskId'] as String,
        completed: (map['completed'] as bool?) ?? true,
      );
}