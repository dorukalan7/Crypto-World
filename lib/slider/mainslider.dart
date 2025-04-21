import 'package:flutter/material.dart';
import 'package:yeniproje/slider/slider_view.dart'; // Bu importun doğru olduğundan emin olun
import 'slider_view.dart';

void main() {
  runApp(const slider());
}

class slider extends StatelessWidget {
  const slider({Key? key}) : super(key: key);  // Burada key parametresi iletildi

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dragon Slayer',
      home: const SliderView(),
    );
  }
}
