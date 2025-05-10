import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KaydolPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _registerUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String formattedEmail = '${_usernameController.text}@example.com';

      try {
        // Firebase Authentication ile kullanıcı kaydı
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: formattedEmail,
          password: _passwordController.text,
        );

        // Kullanıcıyı Firestore'a ekle
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': _usernameController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kayıt başarılı')),
        );

        // Başarılı kayıt sonrası ana ekrana yönlendirme
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kayıt hatası: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Üst mavi bölüm
              Container(
                width: double.infinity,
                height: 932 * 0.2,
                color: Color(0xFF1F74EC),
                padding: EdgeInsets.only(left: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crypto World',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'A Mobile World for Investors',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              // Alt beyaz bölüm
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kayıt Ol',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Kullanıcı Adı alanı
                    Text(
                      'Kullanıcı Adı',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      height: 70,
                      child: Column(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Kullanıcı adı gerekli';
                                } else if (value.length < 3) {
                                  return 'Kullanıcı adı en az 3 karakter olmalı';
                                } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9]).+$').hasMatch(value)) {
                                  return 'Kullanıcı adı en az 1 büyük harf ve 1 sayı içermeli';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Şifre alanı
                    Text(
                      'Şifre',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      height: 70,
                      child: Column(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Şifre gerekli';
                                } else if (value.length < 3) {
                                  return 'Şifre en az 3 karakter olmalı';
                                } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9]).+$').hasMatch(value)) {
                                  return 'Şifre en az 1 büyük harf ve 1 sayı içermeli';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Kayıt Ol butonu
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () => _registerUser(context), // Fonksiyon çağırma
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1F74EC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Kayıt Ol',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
