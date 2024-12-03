import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<ParseObject> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
  final query = QueryBuilder<ParseObject>(ParseObject('Tasks'));
  final response = await query.query();

  if (response.success && response.results != null) {
    // Cast the result to List<ParseObject>
    setState(() {
      tasks = response.results!.cast<ParseObject>();
    });
  } else {
    // Handle errors or empty result
    setState(() {
      tasks = [];
    });
    print('Error fetching tasks: ${response.error?.message}');
  }
}


  Future<void> addTask(String title, DateTime dueDate) async {
    final task = ParseObject('Tasks')
      ..set('title', title)
      ..set('dueDate', dueDate)
      ..set('isCompleted', false);
    await task.save();
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tasks')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.get<String>('title')!),
            subtitle: Text('Due: ${task.get<DateTime>('dueDate')!}'),
            trailing: Checkbox(
              value: task.get<bool>('isCompleted')!,
              onChanged: (value) async {
                task.set('isCompleted', value);
                await task.save();
                fetchTasks();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (context) => AddTaskDialog(),
          );
          if (result != null) {
            addTask(result['title'], result['dueDate']);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController titleController = TextEditingController();
  DateTime? dueDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                setState(() {
                  dueDate = date;
                });
              }
            },
            child: Text('Select Due Date'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {'title': titleController.text, 'dueDate': dueDate});
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
