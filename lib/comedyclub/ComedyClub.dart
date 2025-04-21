import 'package:flutter/material.dart';

void main() {
  runApp(ComedyClubApp());
}

class ComedyClubApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comedy Club',
      debugShowCheckedModeBanner: false,
      home: ComedyHomePage(),
    );
  }
}

class ComedyHomePage extends StatelessWidget {
  final String clubName = '😂 Laugh Lounge Comedy Club';
  final String showInfo = '🎟 Upcoming Show:\nFriday, April 19 - 8:00 PM\nTickets: \$15';
  final String imageUrl =
      'https://images.unsplash.com/photo-1516280440614-37939bbacd81?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Y29tZWR5fGVufDB8fDB8fHww';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(clubName,style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[800],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),

            // Club Image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[900],
                      child: Center(
                        child: Icon(Icons.broken_image, color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 24),

            // Upcoming Show Container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[700],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎭 Upcoming Show',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      showInfo,
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // Gallery Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '📸 Past Highlights',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 12),

            // Gallery Grid
            Container(
              height: 380, // Set height for GridView
              child: GridView.builder(
                shrinkWrap: true, // Ensures grid doesn't take full height of parent
                physics: BouncingScrollPhysics(), // Enable natural scrolling
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  crossAxisSpacing: 8, // Spacing between columns
                  mainAxisSpacing: 8, // Spacing between rows
                  childAspectRatio: 1.0, // Ratio for each grid item
                ),
                itemCount: 6, // Number of items in grid
                itemBuilder: (context, index) {
                  List<String> imageUrls = [
                    'https://images.unsplash.com/photo-1527224857830-43a7acc85260?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y29tZWR5fGVufDB8fDB8fHww',
                    'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
                    'https://images.unsplash.com/photo-1611956425642-d5a8169abd63?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Y29tZWR5fGVufDB8fDB8fHww',
                    'https://images.unsplash.com/photo-1683117855296-979f17e62e87?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8Y29tZWR5fGVufDB8fDB8fHww',
                    'https://images.unsplash.com/photo-1683117851221-7326a05d51f7?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8Y29tZWR5fGVufDB8fDB8fHww',
                    'https://images.unsplash.com/photo-1606145166375-714fe7f24261?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGNvbWVkeXxlbnwwfHwwfHx8MA%3D%3D'
                  ];

                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.network(
                      imageUrls[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
