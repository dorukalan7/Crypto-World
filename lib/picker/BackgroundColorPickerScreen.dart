import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yeniproje/picker/pickermain.dart';
import 'package:yeniproje/picker/profilescreen.dart';

import 'FontPickerScreen.dart';
class BackgroundColorPickerScreen extends StatefulWidget {
  @override
  State<BackgroundColorPickerScreen> createState() => _BackgroundColorPickerScreenState();
}

class _BackgroundColorPickerScreenState extends State<BackgroundColorPickerScreen> {
  Color pickerColor = user.backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pick Background Color')),
      body: Column(
        children: [
          SizedBox(height: 20),
          ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (color) => setState(() => pickerColor = color),
          ),
          ElevatedButton(
            child: Text('Apply & Finish'),
            onPressed: () {
              user.backgroundColor = pickerColor;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
