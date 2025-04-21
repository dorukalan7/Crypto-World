import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yeniproje/picker/pickermain.dart';

import 'FontPickerScreen.dart';

class ImagePickerScreen extends StatelessWidget {
  final ImagePicker picker = ImagePicker();

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      user.image = File(pickedFile.path);
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => FontPickerScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Image')),
      body: Center(
        child: ElevatedButton(
          child: Text('Pick Profile Image'),
          onPressed: () => _pickImage(context),
        ),
      ),
    );
  }
}
