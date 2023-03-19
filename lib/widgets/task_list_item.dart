import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';

class TaskItem extends StatefulWidget {
  Task task;
  TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TextEditingController _taskNameController = TextEditingController();
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    _taskNameController.text = widget.task.name;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              widget.task.isCompleted = !widget.task.isCompleted;
              _localStorage.updateTask(task: widget.task);
            });
          },
          child: ListTile(
            leading: widget.task.isCompleted
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                : const Icon(Icons.circle_outlined),
            title: widget.task.isCompleted
                ? Text(
                    widget.task.name,
                    style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey),
                  )
                : TextField(
                    maxLines: null,
                    controller: _taskNameController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        widget.task.name = value;
                        _localStorage.updateTask(task: widget.task);
                      }
                    },
                  ),
            trailing: Text(
              DateFormat('hh:mm a').format(widget.task.createdAt),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
