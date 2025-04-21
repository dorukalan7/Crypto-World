import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'download_screen.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _imageFile;
  String? _downloadUrl;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    try {
      final fileName = "mascot_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final ref = FirebaseStorage.instance.ref().child('mascots/$fileName');

      final uploadTask = await ref.putFile(_imageFile!);

      final url = await uploadTask.ref.getDownloadURL();

      print("Download URL: $url");

      setState(() {
        _downloadUrl = url;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DownloadScreen(downloadUrl: _downloadUrl!),
        ),
      );
    } catch (e) {
      print("Upload error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choose Your Mascot')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null
                ? Image.file(_imageFile!, height: 200)
                : Text("No image selected."),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.photo),
              label: Text("Choose Mascot"),
            ),
            if (_imageFile != null)
              ElevatedButton.icon(
                onPressed: _uploadImage,
                icon: Icon(Icons.cloud_upload),
                label: Text("Upload Mascot"),
              ),
          ],
        ),
      ),
    );
  }
}
