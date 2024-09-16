import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/todo.dart';
import '../provider/todo_list_provider.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: todoList.when(
        data: (todos) => ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return ListTile(
              title: Text(todo.title),
              trailing: Checkbox(
                value: todo.isCompleted,
                onChanged: (value) {
                  final updatedTodo = Todo(
                    id: todo.id,
                    title: todo.title,
                    isCompleted: value!,
                  );
                  ref.read(todoListProvider.notifier).updateTodo(updatedTodo);
                },
              ),
              onLongPress: () => ref.read(todoListProvider.notifier).deleteTodo(todo.id!),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Todo qo'shish uchun dialog funksiyasi
  void _showAddTodoDialog(BuildContext context, WidgetRef ref) {
    final todoController = TextEditingController(); // TextField uchun controller

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Yangi Todo qo\'shish'),
          content: TextField(
            controller: todoController,
            decoration: const InputDecoration(hintText: 'Todo nomini kiriting'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialogni yopish
              },
              child: const Text('Bekor qilish'),
            ),
            ElevatedButton(
              onPressed: () {
                if (todoController.text.isNotEmpty) {
                  final newTodo = Todo(
                    id: DateTime.now().millisecondsSinceEpoch, // Yangi todo uchun ID
                    title: todoController.text, // Kirtilgan todo nomi
                    isCompleted: false, // Yangi todo doim to'liq bajarilmagan bo'ladi
                  );

                  // Provayder orqali todo qo'shish funksiyasini chaqirish
                  ref.read(todoListProvider.notifier).addTodo(newTodo);

                  Navigator.of(context).pop(); // Dialogni yopish
                }
              },
              child: const Text('Qo\'shish'),
            ),
          ],
        );
      },
    );
  }
}
