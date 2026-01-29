import 'package:autumn/logic/cubit/task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TasksCubit>();

    return Column(
      children: [
        Row(
          children: [
           

            const SizedBox(width: 8),
          
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: BlocBuilder<TasksCubit, List<TodoItem>>(
            builder: (_, items) {
              return ListView(
                children: items
                    .map((t) => ListTile(
                          leading: _RadioToggle(
                            selected: t.done,
                            onTap: () => cubit.toggleDone(t.id),
                          ),
                          title: Text(t.title),
                        ))
                    .toList(),
              );
            },
          ),
        ),
        Center(child:   FilledButton(
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
        child: 
       
             TextField(
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
              child: const Text('Add'),
            ),)
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
    final color = Theme.of(context).colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 2,
            color: selected ? color : Theme.of(context).colorScheme.outline,
          ),
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 120),
          opacity: selected ? 1 : 0,
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}