import 'package:flutter/material.dart';
import 'API.dart';
 // Import your api_service.dart file

void main() => runApp(API());

class API extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
        title: Text('Posts from API'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: apiService.fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          }

          // Display the list of posts
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(posts[index]['title']),
                subtitle: Text(posts[index]['body']),
              );
            },
          );
        },
      ),
    );
  }
}
