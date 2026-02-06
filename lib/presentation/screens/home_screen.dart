import 'package:autumn/logic/cubit/session_state.dart';
import 'package:autumn/logic/cubit/task_cubit.dart';
import 'package:autumn/logic/cubit/timer_cubit.dart';
import 'package:autumn/logic/cubit/timer_state.dart';
import 'package:autumn/presentation/screens/progress_circle.dart';
import 'package:autumn/presentation/screens/todo_list_widget.dart';
import 'package:autumn/sessions_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FocusDashboardScreen extends StatelessWidget {
  final SessionsRepository repo;
  const FocusDashboardScreen({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SessionsCubit(repo)..load()),
        BlocProvider(
          create: (ctx) => TimerCubit(
            onFocusCompleted: ctx.read<SessionsCubit>().addSession,
          ),
        ),
        BlocProvider(create: (_) => TasksCubit()),
      ],
      child: const _FocusDashboardBody(),
    );
  }
}

class _FocusDashboardBody extends StatefulWidget {
  const _FocusDashboardBody({super.key});

  @override
  State<_FocusDashboardBody> createState() => _FocusDashboardScreenState();
}

class _FocusDashboardScreenState extends State<_FocusDashboardBody> {
  TimerMode _modeFromIndex(int i) =>
      i == 0 ? TimerMode.focus : TimerMode.break_;

  Widget _tasksStack() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFBFD9F6), // верх — мягкий голубой
            Color(0xFFEAF2FD), // низ — почти белый
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),

      child: const TodoListWidget(), // ✅ inside tasks section
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  String _formatDateLine(DateTime dt) {
    // simple readable line without intl
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final wd = weekdays[dt.weekday - 1];
    final mo = months[dt.month - 1];
    return '$wd ${dt.day} $mo ${dt.year}, ${_formatTime(dt)}';
  }

  Widget _progressStack() {
    const dailyGoalSessions =
        4; // 🔥 change to 8 or use minutes goal if you want

    return Expanded(
      flex: 1,
      child: BlocBuilder<TimerCubit, TimerState>(
        builder: (context, timerState) {
          final selectedTaskId = timerState.selectedTaskId;

          return BlocBuilder<SessionsCubit, SessionsState>(
            builder: (context, sessionsState) {
              final now = DateTime.now();

              // If no task selected
              if (selectedTaskId == null) {
                return _progressCard(
                  title: 'Daily Progress',
                  doneCountText: 'Select a task',
                  lastSessionText: '—',
                  progress: 0,
                  percentText: '0%',
                );
              }

              // Filter sessions by selected task & today
              final sessionsForTaskToday = sessionsState.sessions.where((s) {
                return s.taskId == selectedTaskId && _sameDay(s.endedAt, now);
              }).toList();

              // last session for this task (all time)
              final allSessionsForTask = sessionsState.sessions
                  .where((s) => s.taskId == selectedTaskId)
                  .toList();

              allSessionsForTask.sort((a, b) => b.endedAt.compareTo(a.endedAt));
              final last = allSessionsForTask.isNotEmpty
                  ? allSessionsForTask.first
                  : null;

              final doneCount = sessionsForTaskToday.length; // sessions today
              final progress = (doneCount / dailyGoalSessions).clamp(0.0, 1.0);
              final percent = (progress * 100).round();

              return _progressCard(
                title: 'Daily Progress',
                doneCountText: '$doneCount / $dailyGoalSessions sessions done',
                lastSessionText: last == null
                    ? 'No sessions yet'
                    : _formatDateLine(last.endedAt),
                progress: progress,
                percentText: '$percent%',
              );
            },
          );
        },
      ),
    );
  }

  Widget _timerStack() {
    return Expanded(
      flex: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFBFD9F6), // верх — мягкий голубой
              Color(0xFFEAF2FD), // низ — почти белый
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),

        child: BlocBuilder<TimerCubit, TimerState>(
          builder: (context, timerState) {
            return BlocBuilder<TasksCubit, List<TodoItem>>(
              builder: (context, tasks) {
                final cubit = context.read<TimerCubit>();
                final selectedId = timerState.selectedTaskId;
                final selectedTask = selectedId == null
                    ? null
                    : tasks.where((t) => t.id == selectedId).firstOrNull;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    BlocBuilder<TimerCubit, TimerState>(
                      builder: (context, state) {
                        return PillToggle(
                          selectedIndex: state.mode == TimerMode.focus ? 0 : 1,
                          onChanged: (i) {
                            context.read<TimerCubit>().changeMode(
                              _modeFromIndex(i),
                            );
                          },
                        );
                      },
                    ),

                    Text(
                      timerState.mmss,
                      style: TextStyle(fontSize: 100, fontWeight: .bold),
                    ),

                    Container(
                      width: 250,
                      padding: .all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.task, size: 18, color: Colors.blue),
                          const SizedBox(width: 6),
                          Text(
                            selectedTask == null
                                ? 'Focus'
                                : ' ${selectedTask.title}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),

                    Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton.icon(
                          onPressed: timerState.isRunning
                              ? cubit.stop
                              : cubit.start,
                          icon: timerState.isRunning
                              ? const Icon(Icons.stop)
                              : const Icon(Icons.play_arrow),
                          label: timerState.isRunning
                              ? const Text('Stop')
                              : const Text('Start'),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        FilledButton.icon(
                          onPressed: cubit.next,
                          icon: const Icon(Icons.skip_next),

                          label: 
                               const Text(''),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ],
                     
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TimerCubit>();

    final gap = 16.0;
    int _selectedIndex = 0;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TimerCubit, TimerState>(
          builder: (_, state) {
            final selectedTaskId = state.selectedTaskId;
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Left: Timer (big)
                    Expanded(flex: 2, child: _tasksStack()),
                    SizedBox(width: gap),

                    // Right: Tasks + Stats stacked
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          children: [
                            _timerStack(),

                            SizedBox(height: gap, width: gap),
                            _progressStack(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class StaticCircle extends StatelessWidget {
  final double size;
  final double strokeWidth;

  const StaticCircle({super.key, this.size = 280, this.strokeWidth = 4});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CirclePainter(
          strokeWidth: strokeWidth,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double strokeWidth;
  final Color color;

  _CirclePainter({required this.strokeWidth, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - strokeWidth / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Segment extends StatelessWidget {
  final bool selected;
  final BorderRadius radius;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _Segment({
    required this.selected,
    required this.radius,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          hoverColor: Colors.transparent, // 🟢 remove hover
          splashColor: Colors.transparent, // 🟢 remove ripple
          highlightColor: Colors.transparent, // 🟢 remove press highlight
          child: Ink(
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.grey.withOpacity(0.1),
              borderRadius: radius,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: selected ? Colors.blue : Colors.grey.withOpacity(1),
                  ),
                  const SizedBox(width: 6),
                  Text(label, style: const TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PillToggle extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const PillToggle({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: SizedBox(
        height: 48,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: _Segment(
                selected: selectedIndex == 0,
                radius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                icon: Icons.timer,

                label: 'Ongoing',
                onTap: () => onChanged(0),
              ),
            ),
            Expanded(
              child: _Segment(
                selected: selectedIndex == 1,
                radius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                icon: Icons.coffee,
                label: 'Break',
                onTap: () => onChanged(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _progressCard({
  required String title,
  required String doneCountText,
  required String lastSessionText,
  required double progress,
  required String percentText,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFBFD9F6), Color(0xFFEAF2FD)],
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          // NOTE: Column has no "spacing" in stable Flutter.
          // Use SizedBox for spacing (works everywhere).
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Text(
                    // show first number if you want, otherwise keep it simple
                    doneCountText.startsWith('Select')
                        ? '!'
                        : doneCountText.split(' ').first,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(doneCountText),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              lastSessionText,
              style: const TextStyle(
                color: Color.fromARGB(255, 132, 125, 125),
                fontWeight: FontWeight.w300,
                fontSize: 12,
              ),
            ),
          ],
        ),

        ProgressCircle(
          progress: progress,
          size: 80,
          strokeWidth: 4,
          center: Container(
            width: 77,
            height: 77,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            alignment: Alignment.center,
            child: Text(
              percentText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    ),
  );
}

extension FirstOrNullExt<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
