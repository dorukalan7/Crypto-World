import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yeniproje/PortfolioScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'KaydolPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase'i başlatın
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginMusteriPage(), // Ana giriş ekranı
    );
  }
}

class LoginMusteriPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> _signInUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String formattedEmail = '${_usernameController.text}@example.com';

      try {
        await _auth.signInWithEmailAndPassword(
          email: formattedEmail,
          password: _passwordController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Giriş başarılı')),
        );

        // MaterialPageRoute kullanarak sayfa geçişi
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PortfolioScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Giriş başarısız: $e')),
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
                      'Giriş Yap',
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
                      height: 45,
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
                          }
                          return null;
                        },
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
                      height: 45,
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
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    // Giriş Yap butonu
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () => _signInUser(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1F74EC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Giriş Yap',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    // "Kayıt Ol" butonu
                    Center(
                      child: TextButton(
                        onPressed: () {
                          print('Kayıt ol butonuna basıldı');
                          // Kayıt olma sayfasına yönlendirme
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => KaydolPage()),
                          );
                        },
                        child: Text(
                          'Kayıt Ol',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF1F74EC),
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
