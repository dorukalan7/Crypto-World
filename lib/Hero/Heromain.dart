import 'package:flutter/material.dart';
import 'package:yeniproje/Hero/successpage.dart';
import 'package:yeniproje/Hero/trappedpage.dart';
import 'package:yeniproje/Hero/welcomepage.dart';

import 'mazepage.dart';

void main() {
  runApp(const hero());
}

class hero extends StatelessWidget {
  const hero({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vampire Maze',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/maze': (context) => const MazePage(),
        '/success': (context) => const SuccessPage(),
        '/trapped': (context) => const TrappedPage(),
      },
    );
  }
}
