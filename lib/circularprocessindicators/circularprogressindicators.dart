import 'package:flutter/material.dart';

void main() {
  runApp(circularprocess());
}

class circularprocess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neon Bee Counter',
      home: BeeCounterScreen(),
    );
  }
}

class BeeCounterScreen extends StatefulWidget {
  @override
  _BeeCounterScreenState createState() => _BeeCounterScreenState();
}

class _BeeCounterScreenState extends State<BeeCounterScreen> {
  bool _isCounting = false;
  int _counter = 0;
  Color _indicatorColor = Colors.amber;

  void _startCounting() async {
    setState(() {
      _isCounting = true;
      _counter = 0;
      _indicatorColor = Colors.amber;
    });

    for (int i = 0; i <= 100; i++) {
      await Future.delayed(Duration(milliseconds: 100));

      setState(() {
        _counter = i;

        if (i % 10 == 0) {
          _indicatorColor = Colors.primaries[i ~/ 10 % Colors.primaries.length];
        }

        if (i == 100) {
          _isCounting = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        title: Text('Neon Bee Challenge 🐝'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isCounting)
              Column(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(_indicatorColor),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Counting: $_counter',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            if (!_isCounting)
              ElevatedButton(
                onPressed: _startCounting,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Start Counting'),
              ),
          ],
        ),
      ),
    );
  }
}
