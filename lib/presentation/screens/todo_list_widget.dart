import 'package:autumn/logic/cubit/task_cubit.dart';
import 'package:autumn/logic/cubit/timer_cubit.dart';
import 'package:autumn/logic/cubit/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';

String formatTime(DateTime date) {
  return DateFormat('h:mm a').format(date);
}

class TodoListWidget extends StatefulWidget {
  const TodoListWidget({super.key});

  @override
  State<TodoListWidget> createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  final controller = TextEditingController();

  

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();

    if (now.difference(d).inDays == 0) return 'Today';

    if (now.difference(d).inDays == 1) return 'Yesterday';

    return '${d.day}.${d.month}.${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TasksCubit>();

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text("Task list", style: TextStyle(fontSize: 16, fontWeight: .normal)),
        
        Row(children: [const SizedBox(width: 8)]),
        const SizedBox(height: 12),
        Expanded(
          child: BlocBuilder<TimerCubit, TimerState>(
            builder: (context, timerState) {
              return BlocBuilder<TasksCubit, List<TodoItem>>(
                builder: (context, items) {
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final t = items[i];
                      final isSelected = timerState.selectedTaskId == t.id;

                      return InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          debugPrint('ROW TAP ${t.id}');
                          context.read<TimerCubit>().selectTask(
                            t.id,
                          ); // ✅ active task
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.withOpacity(0.10)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blue.withOpacity(0.35)
                                  : Colors.transparent,
                            ),
                          ),
                          child: Row(
                            children: [
                              // ✅ radio = complete ONLY (doesn't block row tap)
                              InkWell(
                                
                                borderRadius: BorderRadius.circular(999),
                                onTap: () {
                                  debugPrint('RADIO TAP ${t.id}');
                               
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: _RadioToggle(
                                    selected: t.done,
                                    onTap: () {
                                         context.read<TasksCubit>().toggleDone(t.id);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  t.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                   
                                  ),
                                ),
                              ),
                           



                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),

        Center(
          child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.lightGreen),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) => Dialog(
                  child: SizedBox(
                    width: 420,
                    height: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: 'Напишите тут над чем вы работаете...',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              labelStyle: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  textStyle: TextStyle(fontSize: 12),
                                ),
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: Text(
                                  'Отмена',
                                  style: TextStyle(
                                    color: Colors.black,
                                    backgroundColor: Colors.white12,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  textStyle: TextStyle(fontSize: 12),
                                ),
                                onPressed: () {
                                  cubit.add(controller.text);
                                  controller.clear();
                                },
                                child: Text('Добавить задачу'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );

              // cubit.add(controller.text);
              // controller.clear();
            },
            child: Icon(Icons.add, size: 22 * 0.6, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _RadioToggle extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const _RadioToggle({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Colors.lightGreen;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? color : Colors.transparent,
          border: Border.all(width: 2, color: selected ? color : color),
        ),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 120),
          scale: selected ? 1 : 0,
          child: Icon(Icons.check, size: 22 * 0.6, color: Colors.white),
        ),
      ),
    );
  }
}
