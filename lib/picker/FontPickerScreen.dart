import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yeniproje/picker/pickermain.dart';

import 'DatePickerScreen.dart';
import 'FontPickerScreen.dart';
class FontPickerScreen extends StatelessWidget {
  final fonts = ['Roboto', 'Lobster', 'Oswald', 'Lato'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Font')),
      body: ListView.builder(
        itemCount: fonts.length,
        itemBuilder: (context, index) {
          final font = fonts[index];
          return ListTile(
            title: Text('Sample Text', style: GoogleFonts.getFont(font)),
            onTap: () {
              user.fontFamily = font;
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => DatePickerScreen()));
            },
          );
        },
      ),
    );
  }
}
