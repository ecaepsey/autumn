import 'package:flutter_bloc/flutter_bloc.dart';

class TasksCubit extends Cubit<List<TodoItem>> {
  TasksCubit() : super(const []);

  void add(String title) {
    final t = title.trim();
    if (t.isEmpty) return;

    final item = TodoItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: t,
        createdAt: DateTime.now(),
    );

    emit([item, ...state]);
  }

void toggleDone(String id) {
  final updated = state.map((t) {
    if (t.id != id) return t;
    return t.copyWith(done: !t.done);
  }).toList(growable: false);

  emit(updated);
}

  void remove(String id) {
    emit(state.where((x) => x.id != id).toList(growable: false));
  }
}
class TodoItem {
  final String id;
  final String title;
  final bool done;
   final DateTime createdAt;

  const TodoItem({
    required this.id,
    required this.title,
    this.done = false,
     required this.createdAt,
  });

  TodoItem copyWith({String? title, bool? done}) => TodoItem(
        id: id,
        title: title ?? this.title,
        done: done ?? this.done,
         createdAt: DateTime.now(),
      );
}