import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart'; // Notifier burada tanımlı olduğu için

class WaitingPage extends StatefulWidget {
  @override
  _WaitingPageState createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  int _secondsLeft = 15;
  Timer? _timer;
  String? _decryptedMessage;

  @override
  void initState() {
    super.initState();

    // Geri sayım başlat
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _secondsLeft--;
      });

      if (_secondsLeft == 0) {
        timer.cancel();
        _notifyMessage();
      }
    });

    // Notification dinle
    messageNotifier.addListener(() {
      setState(() {
        _decryptedMessage = messageNotifier.message;
      });

      // 5 saniye sonra ana sayfaya dön
      Future.delayed(Duration(seconds: 5), () {
        Navigator.popUntil(context, (route) => route.isFirst);
        messageNotifier.clear(); // reset
      });
    });
  }

  void _notifyMessage() {
    messageNotifier.setMessage("📡 Mesaj çözüldü: GÖREV BAŞARILI!");
  }

  @override
  void dispose() {
    _timer?.cancel();
    messageNotifier.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Şifre Çözülüyor")),
      body: Center(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: _decryptedMessage == null
              ? Text(
            "Şifre çözülüyor: $_secondsLeft saniye kaldı...",
            style: TextStyle(fontSize: 24),
          )
              : Text(
            _decryptedMessage!,
            key: ValueKey("message"),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
