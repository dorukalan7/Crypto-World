import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Lottiescreen(),
  ));
}

class Lottiescreen extends StatefulWidget {
  @override
  _BlurOpacityLoaderScreenState createState() => _BlurOpacityLoaderScreenState();
}

class _BlurOpacityLoaderScreenState extends State<Lottiescreen>
    with TickerProviderStateMixin {
  double _progress = 0.0;
  double _blurValue = 10.0;
  double _opacity = 0.0;
  bool _loadingDone = false;
  Timer? _timer;

  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    _startLoading();
  }

  void _startLoading() {
    const duration = Duration(milliseconds: 100);
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        _progress += 0.01;
        _blurValue = 10.0 * (1 - _progress);
        _opacity = _progress;

        if (_progress >= 1.0) {
          _progress = 1.0;
          _blurValue = 0.0;
          _opacity = 1.0;
          _loadingDone = true;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _lottieController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan görseli + blur + opacity
          Positioned.fill(
            child: Opacity(
              opacity: _opacity,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: _blurValue, sigmaY: _blurValue),
                child: Image.asset(
                  'assets/images/hero.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Yükleme animasyonu ve yazı
          if (!_loadingDone)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: CircularProgressIndicator(
                      value: _progress,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 150,
                    child: Lottie.asset(
                      'assets/animations/sharpening_loader.json',
                      controller: _lottieController,
                      onLoaded: (composition) {
                        _lottieController
                          ..duration = composition.duration
                          ..repeat();
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Sharpening Image... ${(_progress * 100).toInt()}%",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
