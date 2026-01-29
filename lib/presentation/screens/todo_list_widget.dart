import 'package:autumn/logic/cubit/task_cubit.dart';
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
          child: BlocBuilder<TasksCubit, List<TodoItem>>(
            builder: (_, items) {
              return  Expanded(child: ListView(
                children: items
                    .map(
                      (t) => ListTile(
                        leading: _RadioToggle(
                          selected: t.done,
                          onTap: () => cubit.toggleDone(t.id),
                        ),
                        title: Text(
                          t.title,
                          style: TextStyle(fontSize: 14, fontWeight: .w500),
                        ),
                        trailing: Text(
                          formatTime(t.createdAt),
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(color: Colors.grey),
                        ),
                      ),
                    )
                    .toList(),
              ));
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
                    height: 600,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(hintText: 'Add task'),
                        onSubmitted: (_) {
                          cubit.add(controller.text);
                          controller.clear();
                        },
                      ),
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
