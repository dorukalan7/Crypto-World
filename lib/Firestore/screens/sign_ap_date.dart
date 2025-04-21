import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error signing up: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Kayıt yaparken bir hata oluştu."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Banana Tree Community - Kayıt Ol"),
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
                onPressed: _signUp,
                child: Text("Kayıt Ol"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
