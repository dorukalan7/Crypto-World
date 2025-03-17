import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class FullScreenChart extends StatefulWidget {
  final List<FlSpot> data;
  final bool showRSI;
  final bool showBollingerBands;
  final bool showMovingAverages;

  FullScreenChart({
    required this.data,
    required this.showRSI,
    required this.showBollingerBands,
    required this.showMovingAverages,
  });

  @override
  _FullScreenChartState createState() => _FullScreenChartState();
}

class _FullScreenChartState extends State<FullScreenChart> {
  late bool showRSI;
  late bool showBollingerBands;
  late bool showMovingAverages;
  late ScrollController _scrollController;
  String selectedRange = "1H";
  double _chartScale = 1.0; // Grafik ölçeği
  double _baseScale = 1.0;

  String prediction = "No Prediction Yet"; // Başlangıçta prediction boş
  bool showPrediction = false; // Prediction'ı göstermek için
  List<FlSpot> predictionData = []; // Tahmin verilerini saklayan liste

  final List<String> timeRanges = ["10M", "30M", "1H", "4H", "24H", "7D", "1M"];
  final List<String> indicators = ["RSI", "Bollinger Bands", "Moving Averages"];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    showRSI = widget.showRSI;
    showBollingerBands = widget.showBollingerBands;
    showMovingAverages = widget.showMovingAverages;
  }

  void _onScroll() {
    if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent) {
      _loadOlderData(); // Sol kenara ulaşıldığında eski verileri yükle
    }
  }

  Future<void> _loadOlderData() async {
    List<FlSpot> olderData = List.generate(
      20,
          (index) =>
          FlSpot(
            widget.data.first.x - (index + 1), // x değerlerini geriye al
            Random().nextDouble() * 100, // Rastgele y değerleri
          ),
    );

    setState(() {
      widget.data.insertAll(0, olderData); // Yeni verileri listenin başına ekle
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // ScrollController'ı temizle
    super.dispose();
  }

  // Prediction butonuna basıldığında bu fonksiyon çalışacak
  Future<void> fetchPrediction() async {
    if (showPrediction) {
      setState(() {
        predictionData = [];
        prediction = "No Prediction Yet";
        showPrediction = false;
      });
      return;
    }

    try {
      final response = await http.get(Uri.parse(
          "https://7d6b-34-16-177-8.ngrok-free.app/get_bitcoin_data"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        print("API Yanıtı: ${response.body}");

        // Tahmin ve tarih verilerini alın
        List<dynamic> predictionValues = data['ortalama_tahmin'];
        List<dynamic> dateValues = data['tahmin_tarihleri'];

        List<FlSpot> spots = [];
        for (int i = 0; i < predictionValues.length; i++) {
          double yValue = predictionValues[i].toDouble(); // Tahmin değerleri
          if (yValue.isNaN) continue; // Geçersiz (NaN) değerleri atla

          // Burada dateValues[i]'yi kullanarak doğru xValue'yu hesaplıyoruz
          // Eğer dateValues[i] Unix timestamp formatında ise, milisaniyeye çevirebiliriz
          DateTime predictionDate = DateTime.parse(dateValues[i]);
          double xValue = predictionDate.millisecondsSinceEpoch / 1000.0; // Unix timestamp formatında X değeri

          spots.add(FlSpot(xValue, yValue));
        }


        setState(() {
          predictionData = spots; // Tahmin verilerini ayrı bir listeye kaydet
          prediction = "1 month later: ${predictionValues.last}";
          showPrediction = true;
        });
      } else {
        setState(() {
          prediction =
          "Failed to get prediction. Status Code: ${response.statusCode}";
          showPrediction = false;
        });
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        prediction = "Failed to get prediction. Error: $e";
        showPrediction = false;
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Zaman aralığı ve diğer ayarlar
                PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() {
                      selectedRange = value;
                    });
                  },
                  itemBuilder: (context) {
                    return timeRanges.map((range) {
                      return PopupMenuItem<String>(value: range, child: Text(
                          range, style: TextStyle(color: Colors.black)));
                    }).toList();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                          selectedRange, style: TextStyle(color: Colors.white)),
                      Icon(Icons.arrow_drop_down, color: Colors.white),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                // Diğer ayarlar menüsü
                PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() {
                      if (value == "RSI") showRSI = !showRSI;
                      if (value == "Bollinger Bands")
                        showBollingerBands = !showBollingerBands;
                      if (value == "Moving Averages")
                        showMovingAverages = !showMovingAverages;
                    });
                  },
                  itemBuilder: (context) {
                    return indicators.map((indicator) {
                      return PopupMenuItem<String>(
                        value: indicator,
                        child: Row(
                          children: [
                            Checkbox(
                              value: (indicator == "RSI" && showRSI) ||
                                  (indicator == "Bollinger Bands" &&
                                      showBollingerBands) ||
                                  (indicator == "Moving Averages" &&
                                      showMovingAverages),
                              onChanged: null,
                            ),
                            Text(indicator,
                                style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.settings, color: Colors.white),
                      SizedBox(width: 4),
                      Text("Indicators", style: TextStyle(color: Colors.white)),
                      Icon(Icons.arrow_drop_down, color: Colors.white),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                // Prediction butonu
                Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.white, size: 20),
                      SizedBox(width: 4),
                      GestureDetector(
                        onTap: fetchPrediction,
                        child: Text(
                          showPrediction ? "Prediction" : "Prediction",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Prediction metni
          if (showPrediction)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                prediction,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          // Grafik ekranı
          Expanded(
            child: InteractiveViewer(
              panEnabled: true,
              scaleEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              boundaryMargin: EdgeInsets.all(50),
              onInteractionUpdate: (details) {
                setState(() {
                  _chartScale = details.scale;
                });
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: SizedBox(
                  // Burada tahmin verilerini daha belirgin hale getirecek şekilde genişlik artırılabilir
                  width: (widget.data.length + predictionData.length) * 10.0, // Genişlik daha fazla olabilir
                  height: 90,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22, // Alt eksen başlıkları için yer ayır
                          getTitles: (double value) {
                            DateTime date = DateTime.fromMillisecondsSinceEpoch((value * 1000).toInt());

                            // Tarihlerin 1 ay (30 gün) sonrasına kadar gösterilmesini sağlamak için:
                            DateTime oneMonthLater = date.add(Duration(days: 30));

                            // 1 ay sonrasındaki tarihi formatlı şekilde döndürüyoruz
                            return '${oneMonthLater.year}-${oneMonthLater.month.toString().padLeft(2, '0')}-${oneMonthLater.day.toString().padLeft(2, '0')}';
                          }



                          ,margin: 8,
                          getTextStyles: (context, value) => TextStyle(
                            color: Colors.white, // Tarih yazı rengini beyaz yapıyoruz
                            fontSize: 10, // Yazı boyutunu ayarlayabilirsiniz
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: widget.data, // Mevcut veriler
                          isCurved: true,
                          colors: [Colors.greenAccent],
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: true, colors: [Colors.green.withOpacity(0.3)]),
                        ),
                        if (predictionData.isNotEmpty)
                          LineChartBarData(
                            spots: predictionData, // Tahmin verileri
                            isCurved: true,
                            colors: [Colors.yellow],
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(show: false),
                          ),
                        if (showRSI)
                          LineChartBarData(
                            spots: calculateRSI(widget.data),
                            isCurved: true,
                            colors: [Colors.blue],
                            dotData: FlDotData(show: false),
                          ),
                        if (showBollingerBands)
                          ...calculateBollingerBands(widget.data).map(
                                (band) => LineChartBarData(
                              spots: band,
                              isCurved: true,
                              colors: [Colors.red],
                              dotData: FlDotData(show: false),
                            ),
                          ),
                        if (showMovingAverages)
                          LineChartBarData(
                            spots: calculateMovingAverage(widget.data),
                            isCurved: true,
                            colors: [Colors.yellow],
                            dotData: FlDotData(show: false),
                          ),
                      ],
                    ),
                  ),

                ),
              ),
            ),
          )

        ],
      ),
    );
  }


  List<FlSpot> calculateRSI(List<FlSpot> data) {
    int period = 14;

    if (data.length < period) {
      print("RSI hesaplanamıyor: Yeterli veri yok");
      return [];
    }

    List<double> gains = [];
    List<double> losses = [];

    for (int i = 1; i < data.length; i++) {
      double change = data[i].y - data[i - 1].y;
      if (change > 0) {
        gains.add(change);
        losses.add(0);
      } else {
        gains.add(0);
        losses.add(-change);
      }
    }

    List<double> avgGains = [];
    List<double> avgLosses = [];
    List<double> rs = [];
    List<double> rsi = [];

    for (int i = 0; i < gains.length; i++) {
      if (i < period - 1) continue;

      double avgGain = gains.sublist(i - period + 1, i + 1).reduce((a, b) =>
      a + b) / period;
      double avgLoss = losses.sublist(i - period + 1, i + 1).reduce((a,
          b) => a + b) / period;

      avgGains.add(avgGain);
      avgLosses.add(avgLoss);

      double currentRS = avgGain / (avgLoss == 0 ? 1 : avgLoss);
      rs.add(currentRS);

      double currentRSI = 100 - (100 / (1 + currentRS));
      rsi.add(currentRSI);
    }

    List<FlSpot> rsiSpots = [];
    for (int i = 0; i < rsi.length; i++) {
      rsiSpots.add(FlSpot(data[i + period].x, rsi[i]));
    }

    return rsiSpots;
  }

  List<List<FlSpot>> calculateBollingerBands(List<FlSpot> data) {
    if (data.isEmpty) return [[], []];

    int period = 20;
    List<FlSpot> upperBand = [];
    List<FlSpot> lowerBand = [];

    for (int i = 0; i < data.length; i++) {
      if (i < period - 1) continue;

      List<double> subset = data.sublist(i - period + 1, i + 1).map((
          spot) => spot.y).toList();
      double mean = subset.reduce((a, b) => a + b) / subset.length;
      double stdDev = sqrt(
          subset.map((value) => pow(value - mean, 2)).reduce((a, b) => a + b) /
              subset.length);

      upperBand.add(FlSpot(data[i].x, mean + 2 * stdDev));
      lowerBand.add(FlSpot(data[i].x, mean - 2 * stdDev));
    }

    return [upperBand, lowerBand];
  }


  List<FlSpot> convertToFlSpots(Map<String, dynamic> data) {
    List<dynamic> predictionData = data['ortalama_tahmin'];
    List<dynamic> dateData = data['tahmin_tarihleri'];

    List<FlSpot> spots = [];
    for (int i = 0; i < predictionData.length; i++) {
      double xValue = i.toDouble(); // X değeri olarak index kullanılıyor
      double yValue = predictionData[i]
          .toDouble(); // Y değeri olarak tahmin kullanılıyor
      spots.add(FlSpot(xValue, yValue));
    }
    return spots;
  }


  List<FlSpot> calculateMovingAverage(List<FlSpot> data) {
    if (data.isEmpty) return [];

    int period = 20;
    List<FlSpot> movingAverage = [];

    for (int i = 0; i < data.length; i++) {
      if (i < period - 1) continue;

      double average = data.sublist(i - period + 1, i + 1)
          .map((spot) => spot.y)
          .reduce((a, b) => a + b) / period;
      movingAverage.add(FlSpot(data[i].x, average));
    }

    return movingAverage;
  }
}
