import 'package:flutter/material.dart';
import 'SQLite.dart';

void main() {
  runApp(sqlite());
}

class sqlite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asgard Info',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();

  late Future<List<User>> _users;

  @override
  void initState() {
    super.initState();
    _users = DatabaseHelper.instance.getUsers();
  }

  // Kullanıcıyı veritabanına kaydetme
  void _saveUser() {
    final name = _nameController.text;
    final surname = _surnameController.text;
    final age = int.tryParse(_ageController.text) ?? 0;
    final email = _emailController.text;

    if (name.isNotEmpty && surname.isNotEmpty && email.isNotEmpty) {
      final user = User(name: name, surname: surname, age: age, email: email);
      DatabaseHelper.instance.addUser(user);

      setState(() {
        _users = DatabaseHelper.instance.getUsers();
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User added')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Asgard Info')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) => value!.isEmpty ? 'Please enter name' : null,
                  ),
                  TextFormField(
                    controller: _surnameController,
                    decoration: InputDecoration(labelText: 'Surname'),
                    validator: (value) => value!.isEmpty ? 'Please enter surname' : null,
                  ),
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Please enter age' : null,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) => value!.isEmpty ? 'Please enter email' : null,
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveUser();
                      }
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<User>>(
                future: _users,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No users available.'));
                  }

                  final users = snapshot.data!;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          // Profil simgesi. Burada varsayılan bir simge kullandık.
                          child: Icon(Icons.person),
                          backgroundColor: Colors.blue,
                        ),
                        title: Text('${user.name} ${user.surname}'),
                        subtitle: Text('${user.age} years old - ${user.email}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
