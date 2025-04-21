import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  String _userEmail = '';
  String _userPhotoUrl = '';
  bool _isLoading = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email ?? '';
        _userPhotoUrl = user.photoURL ?? '';
        _isLoading = false;
      });
    }
  }

  Future<void> _pickAndUpdateProfilePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      String fileName = 'profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg';
      try {
        final storageRef = FirebaseStorage.instance.ref().child(fileName);
        await storageRef.putFile(file);

        String photoUrl = await storageRef.getDownloadURL();

        User? user = _auth.currentUser;
        if (user != null) {
          await user.updateProfile(photoURL: photoUrl);
          setState(() {
            _userPhotoUrl = photoUrl;
          });
        }
      } catch (e) {
        print("Error uploading photo: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Banana Tree Community"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          ListTile(
            leading: GestureDetector(
              onTap: _pickAndUpdateProfilePhoto,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: _userPhotoUrl.isEmpty
                    ? AssetImage('assets/default_avatar.png') as ImageProvider
                    : NetworkImage(_userPhotoUrl),
              ),
            ),
            title: Text(
              _userEmail,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickAndUpdateProfilePhoto,
        child: Icon(Icons.add_a_photo),
        tooltip: 'Profil Fotoğrafı Değiştir',
      ),
    );
  }
}
