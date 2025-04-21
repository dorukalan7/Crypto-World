import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:yeniproje/Adapty/main.dart';
import 'inappscreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adapty',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InAppScreen(), // Başlangıç ekranı
      routes: {
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
