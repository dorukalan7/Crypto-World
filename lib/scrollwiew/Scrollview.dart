import 'package:flutter/material.dart';

void main() => runApp(scrollview());

class scrollview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'End of Scroll Demo',
      home: EndOfScrollScreen(),
    );
  }
}

class EndOfScrollScreen extends StatefulWidget {
  @override
  _EndOfScrollScreenState createState() => _EndOfScrollScreenState();
}

class _EndOfScrollScreenState extends State<EndOfScrollScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hasShownAlert = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // ScrollController ile son pozisyona ulaşılıp ulaşılmadığını kontrol et
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent &&
          !_hasShownAlert) {
        _hasShownAlert = true;
        _showEndAlert();
      }
    });
  }

  void _showEndAlert() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('End of Scroll'),
        content: Text('You have reached the end of the scroll view.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // İstersen tekrar gösterilmesi için:
              // setState(() => _hasShownAlert = false);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final labels = List.generate(
      8,
          (i) => Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        padding: EdgeInsets.all(24),
            width: screenWidth * 0.8, // genişliği ekranın %80’i kadar
            height: screenHeight * 0.15, // yüksekliği ekranın %12’si kadar
            alignment: Alignment.center,
        color: Colors.red[(i + 1) * 100],
        child: Text(
          'Label #${i + 1}',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Tony’s Scroll Tool')),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: SizedBox(
          height: screenHeight * 2, // İçerik yüksekliğini 2x ekran yap
          child: Column(
            children: labels,
          ),
        ),
      ),
    );
  }
}
