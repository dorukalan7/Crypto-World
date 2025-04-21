import 'package:flutter/material.dart';

void main() {
  runApp(expanded());
}

class expanded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelEase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TravelDestinationsScreen(),
    );
  }
}

class TravelDestinationsScreen extends StatelessWidget {
  final List<Map<String, String>> destinations = [
    {'title': 'Paris', 'image': 'https://picsum.photos/200/300?random=1'},
    {'title': 'New York', 'image': 'https://picsum.photos/200/300?random=2'},
    {'title': 'Tokyo', 'image': 'https://picsum.photos/200/300?random=3'},
    {'title': 'London', 'image': 'https://picsum.photos/200/300?random=4'},
    {'title': 'Rome', 'image': 'https://picsum.photos/200/300?random=5'},
    {'title': 'Sydney', 'image': 'https://picsum.photos/200/300?random=6'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TravelEase'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 öğe yan yana
            crossAxisSpacing: 8.0, // Yatayda boşluk
            mainAxisSpacing: 50.0, // Dikeyde boşluk
            childAspectRatio: 0.8, // Görsellerin boyut oranı
          ),
          itemCount: destinations.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0), // Her bir öğe arasına boşluk ekler
              child: Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Tıklanma olayını burada işleyebilirsiniz
                    print('Navigating to details for ${destinations[index]['title']}');
                  },
                  child: Card(
                    elevation: 31.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.network(
                            destinations[index]['image']!,
                            fit: BoxFit.cover,
                            height: 150,
                            width: double.infinity,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            destinations[index]['title']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
