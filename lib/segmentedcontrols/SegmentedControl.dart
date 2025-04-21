import 'package:flutter/material.dart';

void main() => runApp(segmentedcontrol());

class segmentedcontrol extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: DinoSegmentedScreen());
  }
}

class DinoSegmentedScreen extends StatefulWidget {
  @override
  _DinoSegmentedScreenState createState() => _DinoSegmentedScreenState();
}

class _DinoSegmentedScreenState extends State<DinoSegmentedScreen> {
  int selectedIndex = 0;

  final List<String> segments = [
    'Neon Academy 2023',
    'Neon',
    'Apps',
  ];

  final List<Color> neonColors = [
    Colors.greenAccent,
    Colors.pinkAccent,
    Colors.blueAccent,
  ];

  double getSegmentWidth() {
    switch (selectedIndex) {
      case 0:
        return 400;
      case 1:
        return 300;
      case 2:
      default:
        return 220;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          width: getSegmentWidth(),
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey.shade900,
          ),
          child: Row(
            children: List.generate(segments.length, (index) {
              bool isSelected = index == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? neonColors[index] : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: neonColors[index].withOpacity(0.6),
                          blurRadius: 12,
                          spreadRadius: 2,
                        )
                      ]
                          : [],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      segments[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isSelected ? 14 : 12,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
