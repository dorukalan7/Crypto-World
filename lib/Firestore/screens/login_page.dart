import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yeniproje/Firestore/screens/sign_ap_date.dart';
import 'home_page.dart';
import 'package:yeniproje/Firestore/screens/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignUpPage()),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error signing in: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Giriş yaparken bir hata oluştu."),
      ));
    }
  }

  Future<void> _navigateToSignUp() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Banana Tree Community - Giriş"),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Şifre"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signIn,
                child: Text("Giriş Yap"),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _navigateToSignUp,
                child: Text(
                  "Hesabınız yok mu? Kayıt Ol",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
