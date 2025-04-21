import 'package:flutter/material.dart';

void main() => runApp(listview());

class listview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListView News',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: NewsScreen(),
    );
  }
}

class News {
  final String title;
  final String description;
  final String imageUrl;

  News({required this.title, required this.description, required this.imageUrl});
}

class NewsScreen extends StatelessWidget {
  final List<News> newsList = List.generate(
    10,
        (index) => News(
      title: 'News Title ${index + 1}',
      description: 'This is a short description of news item ${index + 1}.',
      imageUrl: 'https://picsum.photos/seed/news$index/200/100',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Latest News')),
      body: ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          final news = newsList[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Image.network(news.imageUrl, width: 100, fit: BoxFit.cover),
              title: Text(news.title),
              subtitle: Text(news.description),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NewsDetailScreen(news: news),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final News news;

  NewsDetailScreen({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(news.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(news.imageUrl),
            SizedBox(height: 10),
            Text(news.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(news.description, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
