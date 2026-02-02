
import 'package:autumn/logic/cubit/focus_session.dart';
import 'package:autumn/sessions_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionsState {
  final List<FocusSession> sessions;

  const SessionsState(this.sessions);

  int todayFocusSeconds() {
    final now = DateTime.now();
    bool isSameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    return sessions
        .where((s) => isSameDay(s.endedAt, now))
        .fold(0, (sum, s) => sum + s.durationSeconds);
  }
}

class SessionsCubit extends Cubit<SessionsState> {
  final SessionsRepository repo;

  SessionsCubit(this.repo) : super(const SessionsState([]));

  void load() {
    emit(SessionsState(repo.loadSessions()));
  }

  Future<void> addSession(FocusSession session) async {
    final updated = [session, ...state.sessions];
    emit(SessionsState(updated));
    await repo.saveSessions(updated);
  }
}
