// trapped_page.dart
import 'package:flutter/material.dart';

class TrappedPage extends StatelessWidget {
  const TrappedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '😵 You\'re trapped, try again!',
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
