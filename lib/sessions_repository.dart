import 'package:autumn/logic/cubit/focus_session.dart';
import 'package:hive/hive.dart';

class SessionsRepository {
  final Box box;
  static const _key = 'sessions';

  SessionsRepository(this.box);

  List<FocusSession> loadSessions() {
    final raw = box.get(_key, defaultValue: <dynamic>[]) as List;
    return raw.map((e) => FocusSession.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> saveSessions(List<FocusSession> sessions) async {
    final raw = sessions.map((s) => s.toMap()).toList();
    await box.put(_key, raw);
  }
}
