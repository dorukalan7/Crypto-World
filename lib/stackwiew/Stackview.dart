import 'package:flutter/material.dart';

void main() {
  runApp(stackview());
}

class stackview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harry’s Spell Scroll',
      home: Scaffold(
        appBar: AppBar(
          title: Text("🪄 Harry's Spell Scroll"),
          backgroundColor: Colors.deepPurple,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpellLabel(text: 'Expelliarmus'),
                SizedBox(height: 60),
                SpellLabel(text: 'Stupefy'),
                SizedBox(height: 60),
                SpellLabel(text: 'Lumos'),
                SizedBox(height: 60),
                SpellLabel(text: 'Expecto Patronum'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SpellLabel extends StatelessWidget {
  final String text;
  const SpellLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 22, horizontal: 26),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black26)],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: 'Georgia',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
