import 'package:flutter/material.dart';

void main() => runApp(Steppers());

class Steppers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SarahStepper(),
    );
  }
}

class SarahStepper extends StatefulWidget {
  @override
  _SarahStepperState createState() => _SarahStepperState();
}

class _SarahStepperState extends State<SarahStepper> {
  int outfitCount = 0;
  final int min = 0;
  final int max = 50;
  final int step = 5;

  void increment() {
    setState(() {
      if (outfitCount + step <= max) outfitCount += step;
    });
  }

  void decrement() {
    setState(() {
      if (outfitCount - step >= min) outfitCount -= step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Outfit #: $outfitCount",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(60),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.blue, width: 7),
                  bottom: BorderSide(color: Colors.blue, width: 7),
                ),
                color: Colors.white.withOpacity(0.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: decrement,
                    iconSize: 104,
                    icon: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          'https://i.imgur.com/1H2X5fC.png', // örnek barbie resmi (eksiltme)
                          width: 104,
                          height:104,
                        ),
                        Icon(Icons.favorite, color: Colors.pinkAccent.withOpacity(0.8)),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    onPressed: increment,
                    iconSize: 104,
                    icon: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          'https://i.imgur.com/jT9qv2W.png', // örnek barbie resmi (arttırma)
                          width: 104,
                          height: 104,
                        ),
                        Icon(Icons.favorite, color: Colors.pinkAccent.withOpacity(0.8)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
