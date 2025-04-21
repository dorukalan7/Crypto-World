import 'package:flutter/material.dart';

void main() {
  runApp(screenanimation());
}

class screenanimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ulfr\'ın Animasyonları',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: AnimationHomePage(),
    );
  }
}

class AnimationHomePage extends StatefulWidget {
  @override
  _AnimationHomePageState createState() => _AnimationHomePageState();
}

class _AnimationHomePageState extends State<AnimationHomePage> with TickerProviderStateMixin {
  bool isVisible = true;
  double rotation = 0.0;
  double position = 0.0;
  double size = 100.0;

  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      lowerBound: -1.0,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('⚔️ Ulfr\'ın Animasyon Büyüleri')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Görünmezlik büyüsü
            Visibility(
              visible: isVisible,
              child: Container(
                width: size,
                height: size,
                color: Colors.amber,
                alignment: Alignment.center,
                child: Text('✨ Büyülü Kutu'),
              ),
            ),
            SizedBox(height: 20),

            // Dönme büyüsü
            RotationTransition(
              turns: _rotationController,
              child: Icon(Icons.shield, size: 60, color: Colors.blueAccent),
            ),
            SizedBox(height: 30),

            // Hareket büyüsü
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              transform: Matrix4.translationValues(0, position, 0),
              child: Text(
                '⚔️ Viking Ruhu',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 40),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => isVisible = !isVisible),
                  child: Text(isVisible ? 'Gizle' : 'Göster'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // %25 sola döndürme: 0.25 tur (90 derece)
                      _rotationController.value -= 0.25;

                      // Eğer değer -1'in altına düşerse başa sar
                      if (_rotationController.value < -1.0) {
                        _rotationController.value += 2.0;
                      }
                    });
                  },
                  child: Text('Sola Döndür'),
                ),

                ElevatedButton(
                  onPressed: () {
                    setState(() => position -= 30);
                  },
                  child: Text('Yukarı Taşı'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() => position += 30);
                  },
                  child: Text('Aşağı Taşı'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() => size += 20);
                  },
                  child: Text('Büyüt'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() => size = (size - 20).clamp(50.0, 200.0));
                  },
                  child: Text('Küçült'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
