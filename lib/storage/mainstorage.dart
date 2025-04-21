import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yeniproje/storage/screens/upload_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(storage());
}

class storage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Team Mascot Picker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UploadScreen(),
    );
  }
}
