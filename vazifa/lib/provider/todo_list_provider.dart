import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/todo.dart';
import '../service/todo_service.dart';

part 'todo_list_provider.g.dart';

@riverpod
class TodoList extends _$TodoList {
  final TodoService _todoService = TodoService();

  @override
  Future<List<Todo>> build() async {
    return _todoService.fetchTodos();
  }

  Future<void> addTodo(Todo todo) async {
    // Asinxron holatni kutib olish
    final currentTodos =
        state.value ?? []; // Agar state null bo'lsa, bo'sh ro'yxatni oling
    await _todoService.addTodo(todo);

    // Holatni yangilash uchun AsyncValue.data() dan foydalaning
    state = AsyncValue.data([...currentTodos, todo]);
  }

  Future<void> updateTodo(Todo todo) async {
    final currentTodos = state.value ?? []; // Asinxron qiymatni olish
    await _todoService.updateTodo(todo);

    // Yangilangan ro'yxatni qaytarish
    final updatedTodos =
        currentTodos.map((t) => t.id == todo.id ? todo : t).toList();
    state = AsyncValue.data(updatedTodos);
  }

  Future<void> deleteTodo(int id) async {
    final currentTodos = state.value ?? []; // Asinxron qiymatni olish
    await _todoService.deleteTodo(id);

    // O'chirilgan elementni ro'yxatdan chiqarib tashlash
    final updatedTodos = currentTodos.where((t) => t.id != id).toList();
    state = AsyncValue.data(updatedTodos);
  }
}
