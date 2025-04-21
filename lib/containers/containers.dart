import 'package:flutter/material.dart';

void main() {
  runApp(container());
}

class container extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awesome Gallery',
      debugShowCheckedModeBanner: false,
      home: ImageListPage(),
    );
  }
}

class ImageListPage extends StatelessWidget {
  final List<String> imageUrls = [
    'https://picsum.photos/id/1015/400/300',
    'https://picsum.photos/id/1016/400/300',
    'https://picsum.photos/id/1018/400/300',
    'https://picsum.photos/id/1021/400/300',
    'https://picsum.photos/id/1025/400/300',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Awesome Gallery'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Kullanıcı bir görsele tıkladığında detay sayfasına gider
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageDetailPage(imageUrl: imageUrls[index]),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.deepPurple, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(imageUrls[index]),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2),
                      BlendMode.darken,
                    ),
                  ),
                ),
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.all(12),
                child: Text(
                  'Görsel ${index + 1}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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

class ImageDetailPage extends StatelessWidget {
  final String imageUrl;

  const ImageDetailPage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detay"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.deepPurple, width: 2),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.bottomRight,
          child: Container(
            color: Colors.black54,
            padding: EdgeInsets.all(8),
            child: Text(
              "Favorilere ekle →",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
