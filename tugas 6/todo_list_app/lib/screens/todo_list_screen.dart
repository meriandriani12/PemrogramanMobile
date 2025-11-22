import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:todo_list_app/models/todo.dart';
import 'package:todo_list_app/widgets/add_edit_todo_dialog.dart';

enum Filter { all, completed, incomplete }

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Todo> _todos = [];
  Filter _filter = Filter.all;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosString = prefs.getString('todos');
    if (todosString != null) {
      final List<dynamic> todoList = jsonDecode(todosString);
      setState(() {
        _todos.clear();
        _todos.addAll(todoList.map((json) => Todo.fromJson(json)).toList());
      });
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String todosString =
        jsonEncode(_todos.map((todo) => todo.toJson()).toList());
    await prefs.setString('todos', todosString);
  }

  void _addTodo(String title) {
    if (title.isNotEmpty) {
      setState(() {
        _todos.add(Todo(title: title));
      });
      _saveTodos();
    }
  }

  void _toggleTodo(int index) {
    setState(() {
      _getFilteredTodos()[index].isDone = !_getFilteredTodos()[index].isDone;
    });
    _saveTodos();
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.remove(_getFilteredTodos()[index]);
    });
    _saveTodos();
  }

  void _editTodo(int index, String newTitle) {
    setState(() {
      _getFilteredTodos()[index].title = newTitle;
    });
    _saveTodos();
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddEditTodoDialog(
          onSave: (title) {
            _addTodo(title);
          },
        );
      },
    );
  }

  void _showEditTodoDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AddEditTodoDialog(
          todo: _getFilteredTodos()[index],
          onSave: (newTitle) {
            _editTodo(index, newTitle);
          },
        );
      },
    );
  }

  List<Todo> _getFilteredTodos() {
    switch (_filter) {
      case Filter.completed:
        return _todos.where((todo) => todo.isDone).toList();
      case Filter.incomplete:
        return _todos.where((todo) => !todo.isDone).toList();
      case Filter.all:
      default:
        return _todos;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTodos = _getFilteredTodos();
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logo.png'),
        ),
        title: const Text('Todo List'),
        actions: [
          PopupMenuButton<Filter>(
            onSelected: (Filter filter) {
              setState(() {
                _filter = filter;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Filter>>[
              const PopupMenuItem<Filter>(
                value: Filter.all,
                child: Text('All'),
              ),
              const PopupMenuItem<Filter>(
                value: Filter.completed,
                child: Text('Selesai'),
              ),
              const PopupMenuItem<Filter>(
                value: Filter.incomplete,
                child: Text('Belum Selesai'),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredTodos.length,
        itemBuilder: (context, index) {
          final todo = filteredTodos[index];
          return ListTile(
            leading: Checkbox(
              value: todo.isDone,
              onChanged: (value) {
                _toggleTodo(index);
              },
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditTodoDialog(index);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteTodo(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
