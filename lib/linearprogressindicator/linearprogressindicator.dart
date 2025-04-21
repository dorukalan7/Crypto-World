import 'package:flutter/material.dart';

void main() {
  runApp(linearprogressindicator());
}

class linearprogressindicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aladdin’s Progress',
      home: AladdinProgressScreen(),
    );
  }
}

class AladdinProgressScreen extends StatefulWidget {
  @override
  _AladdinProgressScreenState createState() => _AladdinProgressScreenState();
}

class _AladdinProgressScreenState extends State<AladdinProgressScreen> {
  int _progress = 0;
  final int _maxProgress = 10;

  void _increaseProgress() {
    setState(() {
      _progress = (_progress + 1) % (_maxProgress + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    double _progressValue = _progress / _maxProgress;

    return Scaffold(
      appBar: AppBar(
        title: Text('🧞 Aladdin\'s Progress Tracker',style: TextStyle(color: Colors.white), // Yazı rengini beyaz yapar
        ),

        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[900],

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Progress: $_progress / $_maxProgress',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: _progressValue,
              minHeight: 20,
              backgroundColor: Colors.black,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _increaseProgress,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              child: Text(
                'I\'ve made progress!',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
