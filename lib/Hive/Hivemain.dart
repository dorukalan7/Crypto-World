import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'Hivemain.g.dart';// build_runner bunu oluşturacak

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');

  runApp(Hivetask());
}

class Hivetask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskMaster',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: TaskMasterScreen(),
    );
  }
}

class TaskMasterScreen extends StatelessWidget {
  final Box<Task> taskBox = Hive.box<Task>('tasks');

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Yeni Görev Ekle'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Görev başlığı girin'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final task = Task(title: controller.text);
                taskBox.add(task);
              }
              Navigator.pop(context);
            },
            child: Text('Ekle'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('📝 TaskMaster')),
      body: ValueListenableBuilder(
        valueListenable: taskBox.listenable(),
        builder: (context, Box<Task> box, _) {
          if (box.isEmpty) {
            return Center(child: Text('Henüz görev yok.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final task = box.getAt(index)!;

              return ListTile(
                leading: Icon(Icons.person,
                    color: task.isCompleted ? Colors.green : Colors.grey),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => task.delete(),
                ),
                onTap: () {
                  task.isCompleted = !task.isCompleted;
                  task.save();
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
