import 'package:autumn/logic/cubit/task_cubit.dart';
import 'package:autumn/logic/cubit/timer_cubit.dart';
import 'package:autumn/logic/cubit/timer_state.dart';
import 'package:autumn/presentation/screens/todo_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FocusDashboardScreen extends StatelessWidget {
  const FocusDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TimerCubit(totalSeconds: 25 * 60)),
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

  Widget _timerStack(TimerState state, TimerCubit cubit) {
    return Expanded(
      flex: 2,
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

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            BlocBuilder<TimerCubit, TimerState>(
              builder: (context, state) {
                return PillToggle(
                  selectedIndex: state.mode == TimerMode.focus ? 0 : 1,
                  onChanged: (i) {
                    context.read<TimerCubit>().changeMode(_modeFromIndex(i));
                  },
                );
              },
            ),

            Text(
              state.mmss,
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
                  Icon(Icons.time_to_leave, size: 18, color: Colors.blue),
                  const SizedBox(width: 6),
                  Text(
                    'Time to focus',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),

            FilledButton.icon(
              onPressed: state.isRunning ? cubit.stop : cubit.start,
              icon: state.isRunning
                  ? const Icon(Icons.stop)
                  : const Icon(Icons.play_arrow),
              label: state.isRunning ? const Text('Stop') : const Text('Start'),
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
          ],
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
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Left: Timer (big)
                   Expanded(
                    flex: 2,
                    child: _tasksStack()),
                    SizedBox(width: gap),

                    // Right: Tasks + Stats stacked
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          children: [
                               _timerStack(state, cubit),
                           
                            SizedBox(height: gap, width: gap),
                            Expanded(
                              flex: 2,
                              child: ListView(
                                children: const [
                                  ListTile(title: Text('Write Flutter UI')),
                                  ListTile(title: Text('Add timer logic')),
                                  ListTile(title: Text('Create tasks page')),
                                ],
                              ),
                            ),
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
