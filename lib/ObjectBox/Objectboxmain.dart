import 'package:flutter/material.dart';
import 'objectbox.g.dart';
import 'Objectbox.dart';
 // bu dosya build_runner ile oluşacak

late final Store store;
late final Box<CoralFragment> fragmentBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  store = await openStore();
  fragmentBox = store.box<CoralFragment>();

  runApp(objectbox());
}

class objectbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CoralMemoryScreen(),
    );
  }
}

class CoralMemoryScreen extends StatefulWidget {
  @override
  _CoralMemoryScreenState createState() => _CoralMemoryScreenState();
}

class _CoralMemoryScreenState extends State<CoralMemoryScreen> {
  final titleCtrl = TextEditingController();
  final speciesCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final detailsCtrl = TextEditingController();

  void _addFragment() {
    final fragment = CoralFragment(
      title: titleCtrl.text,
      species: speciesCtrl.text,
      date: dateCtrl.text,
      details: detailsCtrl.text,
    );
    fragmentBox.put(fragment);
    setState(() {});
  }

  void _deleteFragment(int id) {
    fragmentBox.remove(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final fragments = fragmentBox.getAll();

    return Scaffold(
      appBar: AppBar(title: Text('🌊 Coral Memory')),
      body: ListView(
        children: fragments.map((fragment) {
          return ListTile(
            title: Text(fragment.title),
            subtitle: Text('${fragment.species} - ${fragment.date}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteFragment(fragment.id),
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Yeni Coral Fragment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: InputDecoration(labelText: 'Başlık')),
            TextField(controller: speciesCtrl, decoration: InputDecoration(labelText: 'Tür')),
            TextField(controller: dateCtrl, decoration: InputDecoration(labelText: 'Tarih')),
            TextField(controller: detailsCtrl, decoration: InputDecoration(labelText: 'Detaylar')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _addFragment();
              Navigator.pop(context);
            },
            child: Text('Ekle'),
          )
        ],
      ),
    );
  }
}
