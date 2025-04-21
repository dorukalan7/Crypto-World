import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(Textfield());
}

class Textfield extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: KraliceFormu(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class KraliceFormu extends StatefulWidget {
  @override
  _KraliceFormuState createState() => _KraliceFormuState();
}

class _KraliceFormuState extends State<KraliceFormu> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _emailError;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Email doğrulama
  bool _isEmailValid(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  void _validateEmail() {
    setState(() {
      _emailError =
      _isEmailValid(_emailController.text) ? null : "Geçersiz email formatı!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("👑 Kraliçenin Formu"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Ad Soyad TextField
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Enter Name-Surname",
                labelStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                FocusScope.of(context).unfocus(); // Klavyeyi kapat
              },
            ),
            SizedBox(height: 20),

            // Email TextField
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Enter Email",
                labelStyle: TextStyle(color: Colors.blue, fontStyle: FontStyle.italic),
                errorText: _emailError,
              ),
              style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) => _validateEmail(),
            ),
            SizedBox(height: 20),

            // Telefon Numarası TextField
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: "Enter Phone Number",
                labelStyle: TextStyle(
                  color: Colors.green,
                  decoration: TextDecoration.underline,
                ),
              ),
              style: TextStyle(
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10), // Maksimum 10 karakter
                FilteringTextInputFormatter.digitsOnly, // Sadece rakamlar
              ],
            ),
          ],
        ),
      ),
    );
  }
}
