import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yeniproje/Firestore/screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(firestore());
}

class firestore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banana Tree Community',
      theme: ThemeData(primarySwatch: Colors.green),
      home: LoginPage(),
    );
  }
}
