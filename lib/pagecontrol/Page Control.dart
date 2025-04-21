import 'package:flutter/material.dart';

void main() {
  runApp(pagecontrol());
}

class pagecontrol extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PageControlScreen(),
    );
  }
}

class PageControlScreen extends StatefulWidget {
  @override
  _PageControlScreenState createState() => _PageControlScreenState();
}

class _PageControlScreenState extends State<PageControlScreen> {
  PageController _pageController = PageController();
  int currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'title': 'The Sunrise Scroll',
      'subtitle': 'Wisdom of the morning light',
      'image': 'https://i.imgur.com/8Km9tLL.jpg',
    },
    {
      'title': 'The Royal Code',
      'subtitle': 'Secrets of the digital throne',
      'image': 'https://i.imgur.com/BoN9kdC.png',
    },
    {
      'title': 'The Kingdom Map',
      'subtitle': 'Where magic meets data',
      'image': 'https://i.imgur.com/OvMZBs9.jpg',
    },
  ];

  final List<Color> bgColors = [
    Colors.deepPurple.shade100,
    Colors.cyan.shade100,
    Colors.orange.shade100,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        color: bgColors[currentPage],
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            pages[index]['title']!,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            pages[index]['subtitle']!,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 24),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              pages[index]['image']!,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              buildPageIndicator(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pages.length, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 6),
          width: currentPage == index ? 36 : 12,
          height: 12,
          decoration: BoxDecoration(
            color: currentPage == index
                ? Colors.black.withOpacity(0.8)
                : Colors.black26,
            borderRadius: BorderRadius.circular(6),
            image: currentPage == index
                ? DecorationImage(
              image: NetworkImage(pages[index]['image']!),
              fit: BoxFit.cover,
            )
                : null,
          ),
        );
      }),
    );
  }
}
