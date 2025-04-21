import 'package:flutter/material.dart';

import 'HTTP.dart';
 // Import your API service file

void main() => runApp(Http());

class Http extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barbie & Ken Reunion',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barbie & Ken Messages'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: apiService.fetchMessages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No messages yet.'));
          }

          // Display the messages
          final messages = snapshot.data!;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return ListTile(
                title: Text('Message #${message['id']}'),
                subtitle: Text(message['title']),
              );
            },
          );
        },
      ),
    );
  }
}
