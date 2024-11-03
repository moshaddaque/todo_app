import 'package:flutter/material.dart';
import 'package:todo_app/HomeScreen/home_screen.dart';

class TodoDetailScreen extends StatefulWidget {
  final Todo todo;
  final int index;
  final Function(int, Todo) updateTodo;
  const TodoDetailScreen({
    super.key,
    required this.todo,
    required this.index,
    required this.updateTodo,
  });

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  late Todo todo;

  @override
  void initState() {
    todo = widget.todo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
        actions: [
          IconButton(
            onPressed: () {
              _editTodo(todo, context);
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Title:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              todo.title,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Description:',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            todo.description.isNotEmpty
                ? Text(
                    todo.description,
                    style: const TextStyle(fontSize: 18),
                  )
                : const Text(
                    "Description is empty",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
          ],
        ),
      ),
    );
  }

  void _editTodo(Todo todo, BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    titleController.text = todo.title;
    descriptionController.text = todo.description;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Your Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Update task Title',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Update Description',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    todo.title = titleController.text;

                    todo.description = descriptionController.text.isNotEmpty
                        ? descriptionController.text
                        : "";
                  });
                  widget.updateTodo(
                    widget.index,
                    Todo(
                      title: titleController.text,
                      description: descriptionController.text.isNotEmpty
                          ? descriptionController.text
                          : "",
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Must Be Provide Title"),
                    ),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
