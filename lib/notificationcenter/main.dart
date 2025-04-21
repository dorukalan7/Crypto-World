import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yeniproje/notificationcenter/waiting_page.dart';

import 'message_notifier.dart';

void main() {
  runApp(notificationcenter());
}

final messageNotifier = MessageNotifier();

class notificationcenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DecryptPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DecryptPage extends StatefulWidget {
  @override
  _DecryptPageState createState() => _DecryptPageState();
}

class _DecryptPageState extends State<DecryptPage> {
  final _secretCode = "1234";
  String _userCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gizli Görev")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                child: Text("şifre 1234 yazmamız lazım"),
                onPressed: () {},
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: "Gizli Kod"),
                obscureText: true,
                onChanged: (val) => _userCode = val,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text("Devam Et"),
                onPressed: () {
                  if (_userCode == _secretCode) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WaitingPage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("❌ Kod yanlış!")),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
