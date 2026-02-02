class FocusSession {
  final DateTime endedAt;
  final int durationSeconds;
  final String taskId; // ✅ required

  const FocusSession({
    required this.endedAt,
    required this.durationSeconds,
    required this.taskId,
  });

  Map<String, dynamic> toMap() => {
        'endedAt': endedAt.toIso8601String(),
        'durationSeconds': durationSeconds,
        'taskId': taskId,
      };

  static FocusSession fromMap(Map map) => FocusSession(
        endedAt: DateTime.parse(map['endedAt'] as String),
        durationSeconds: map['durationSeconds'] as int,
        taskId: map['taskId'] as String,
      );
}
