import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yeniproje/picker/ImagePickerScreen.dart' show ImagePickerScreen;
import 'package:yeniproje/picker/pickermain.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.getFont(user.fontFamily, fontSize: 20);

    return Scaffold(
      backgroundColor: user.backgroundColor,
      appBar: AppBar(title: Text('Profile Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage:
              user.image != null ? FileImage(user.image!) : null,
              child: user.image == null ? Icon(Icons.person, size: 60) : null,
            ),
            SizedBox(height: 16),
            Text('Name: ${user.name}', style: textStyle),
            Text('Age: ${user.age}', style: textStyle),
            SizedBox(height: 32),
            ElevatedButton(
              child: Text('Continue'),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ImagePickerScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
