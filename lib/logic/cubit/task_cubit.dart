import 'package:flutter_bloc/flutter_bloc.dart';

class TasksCubit extends Cubit<List<TodoItem>> {
  TasksCubit() : super(const []);

  void add(String title) {
    final t = title.trim();
    if (t.isEmpty) return;

    final item = TodoItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: t,
    );

    emit([item, ...state]);
  }

  void toggleDone(String id) {
    emit([
      for (final x in state)
        if (x.id == id) x.copyWith(done: !x.done) else x
    ]);
  }

  void remove(String id) {
    emit(state.where((x) => x.id != id).toList(growable: false));
  }
}
class TodoItem {
  final String id;
  final String title;
  final bool done;

  const TodoItem({
    required this.id,
    required this.title,
    this.done = false,
  });

  TodoItem copyWith({String? title, bool? done}) => TodoItem(
        id: id,
        title: title ?? this.title,
        done: done ?? this.done,
      );
}