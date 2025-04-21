import 'package:flutter/material.dart';

class SliderView extends StatefulWidget {
  const SliderView({Key? key}) : super(key: key); // key parametresini manuel iletme

  @override
  _SliderViewState createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView> {
  double _sliderValue = 25; // Slider'ın başlangıç değeri

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dragon Slayer Slider")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Yeşil Ejderha, Slider ve Kırmızı Ejderha için Row Düzeni
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/green_dragon.png', height: 50, width: 50),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.transparent,
                      inactiveTrackColor: Colors.transparent,
                      thumbColor: Colors.blue, // Thumb'un rengi
                      thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 12),
                      overlayColor:
                      Colors.blue.withValues(alpha: 0.2), // Hover efekti
                      trackShape: GradientTrackShape(), // Gradient track
                    ),
                    child: Slider(
                      value: _sliderValue,
                      min: 0,
                      max: 50, // Maksimum değer 50 olarak güncellendi
                      divisions: 50, // 1'er adımlarla artış
                      onChanged: (double newValue) {
                        setState(() {
                          _sliderValue = newValue;

                          // Kırmızı ejderha aksiyonu
                          if (_sliderValue == 50) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Red Dragon Alert!"),
                                content: const Text(
                                    "The red dragon is unleashed! Prepare for battle."),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                        });
                      },
                    ),
                  ),
                ),
                Image.asset('assets/images/red_dragon.png', height: 50, width: 50),
              ],
            ),
            const SizedBox(height: 16),

            // Slider Değeri Gösterimi
            Text(
              "Slider Value: ${_sliderValue.toInt()}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// Gradient İçin Track Şekli
class GradientTrackShape extends SliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        bool isEnabled = false,
        bool isDiscrete = false,
        required TextDirection textDirection,
        required Offset thumbCenter,
        Offset? secondaryOffset,
      }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Gradient gradient = LinearGradient(
      colors: [Colors.green, Colors.red],
    );

    final Paint paint = Paint()
      ..shader = gradient.createShader(trackRect);

    context.canvas.drawRect(trackRect, paint);
  }
}