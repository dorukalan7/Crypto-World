import 'package:flutter/material.dart';

void main() {
  runApp(switches());
}

class switches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MagicalSwitchScreen(),
    );
  }
}

class MagicalSwitchScreen extends StatefulWidget {
  @override
  _MagicalSwitchScreenState createState() => _MagicalSwitchScreenState();
}

class _MagicalSwitchScreenState extends State<MagicalSwitchScreen> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isOn ? Colors.green : Colors.red,
      body: Center(
        child: Switch(
          value: isOn,
          onChanged: (value) {
            setState(() {
              isOn = value;
            });
          },
          activeTrackColor: Colors.red, // switch açıkken track rengi
          inactiveTrackColor: Colors.green, // switch kapalıyken track rengi
          activeColor: Colors.black, // thumb rengi açıkken
          inactiveThumbColor: Colors.black, // thumb rengi kapalıyken
        ),
      ),
    );
  }
}
