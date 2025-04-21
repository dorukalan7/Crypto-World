import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yeniproje/picker/pickermain.dart';
import 'package:yeniproje/picker/profilescreen.dart';


void main() => runApp(picker());

class picker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile App',
      home: ProfileScreen(), // Burayı düzelttik
    );
  }
}


// Shared State
class UserData {
  File? image;
  String name = "John Doe";
  int age = 20;
  String fontFamily = 'Roboto';
  Color backgroundColor = Colors.white;
}

final user = UserData();
