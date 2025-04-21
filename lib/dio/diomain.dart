import 'package:flutter/material.dart';
import 'dio.dart'; // Import the DioService file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MelodyMaker',
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
  final DioService _dioService = DioService();
  late Future<List<dynamic>> _musicData;

  @override
  void initState() {
    super.initState();
    // Fetch music data
    _musicData = _dioService.fetchUsers();  // You can change this to fetchMusicData() or others
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MelodyMaker'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _musicData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No music available.'));
          }

          // Display music data
          final songs = snapshot.data!;
          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return ListTile(
                title: Text(song['name'] ?? 'No name available'),  // Assuming 'name' is part of the response
                subtitle: Text(song['artist'] ?? 'No artist available'),  // Assuming 'artist' is part of the response
              );
            },
          );
        },
      ),
    );
  }
}
