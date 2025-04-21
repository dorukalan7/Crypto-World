import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yeniproje/picker/pickermain.dart';

import 'BackgroundColorPickerScreen.dart';
import 'FontPickerScreen.dart';
class DatePickerScreen extends StatelessWidget {
  void _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      final today = DateTime.now();
      user.age = today.year - pickedDate.year;
      if (today.month < pickedDate.month ||
          (today.month == pickedDate.month && today.day < pickedDate.day)) {
        user.age--;
      }
    }

    Navigator.push(context,
        MaterialPageRoute(builder: (_) => BackgroundColorPickerScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Birthdate')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _pickDate(context),
          child: Text('Pick Date'),
        ),
      ),
    );
  }
}
