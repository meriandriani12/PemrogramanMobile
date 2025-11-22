import 'package:flutter/material.dart';
import 'package:todo_list_app/models/todo.dart';

class AddEditTodoDialog extends StatelessWidget {
  final Todo? todo;
  final Function(String) onSave;

  const AddEditTodoDialog({super.key, this.todo, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: todo?.title ?? '');
    return AlertDialog(
      title: Text(todo == null ? 'Add Todo' : 'Edit Todo'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Todo Title'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onSave(controller.text);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
