import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';

import 'FullScreenChart.dart';


class BitcoinScreen extends StatefulWidget {
  @override
  _BitcoinScreenState createState() => _BitcoinScreenState();
}

class _BitcoinScreenState extends State<BitcoinScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Map<String, List<FlSpot>> chartData = {
    for (var range in ['10m', '30m', '1h', '4h', '24h', '7d', '1m']) range: []
  };
  String selectedRange = '1h';
  double? lastPrice;
  double? highPrice;
  double? lowPrice;
  double? change;
  bool isLoading = false; // Yükleme durumunu izlemek için
  Timer? _timer; // Timer değişkeni
  bool showRSI = false;
  bool showBollingerBands = false;
  bool showMovingAverages = false;

  final List<String> ranges = [
    '10m', '30m', '1h', '4h', '24h', '7d', '1m'
  ];

  List<double> anomalies = [];
  String formatNumber(double value) {
    final NumberFormat formatter = NumberFormat('#0.000'); // 3 ondalıklı gösterim
    return formatter.format(value);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: ranges.length, vsync: this);
    _fetchChartData();
    // 10 saniyede bir _fetchChartData() fonksiyonunu çağırmak için Timer oluşturuyoruz
    _timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      if (!isLoading) { // Yükleme sırasında tekrar çağırmaktan kaçının
        _fetchChartData();}});


    _tabController!.addListener(() {
      setState(() {
        selectedRange = ranges[_tabController!.index];
        _fetchChartData();
      });
    });
  }
  @override
  void dispose() {
    _timer?.cancel(); // Widget kapatıldığında timer'ı durduruyoruz
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _fetchChartData() async {
    setState(() {
      isLoading = true; // Yükleme başlıyor
      anomalies = []; // Anomali listesini temizliyoruz
    });

    try {
      Map<String, List<FlSpot>> data = await fetchCryptoChartData(selectedRange);
      List<double> prices = data[selectedRange]?.map((spot) => spot.y).toList() ?? [];

      // Ortak anomalileri tespit et
      List detectedAnomalies = detectCommonAnomalies(prices);

      setState(() {
        chartData.addAll(data); // Gelen veriyi mevcut veriye ekliyoruz
        anomalies = detectedAnomalies.cast<double>(); // Anomalileri güncelliyoruz
        _calculatePriceStats();
      });

      // İndikatörleri yeniden hesapla (indikatörler için geçici setState)
      setState(() {});
    } catch (e) {
      print("Hata: $e");
    } finally {
      setState(() {
        isLoading = false; // Yükleme tamamlandı
      });
    }
  }




  void _calculatePriceStats() {
    if (chartData != null && chartData![selectedRange]!.isNotEmpty) {
      final prices = chartData![selectedRange]!.map((spot) => spot.y).toList();
      lastPrice = prices.last;
      highPrice = prices.reduce((a, b) => a > b ? a : b);
      lowPrice = prices.reduce((a, b) => a < b ? a : b);
      change = prices.last - prices.first;
    }
  }


  // Z-Score ile anomali tespiti
  List<double> detectAnomaliesWithZScore(List<double> prices, double threshold) {
    double mean = prices.reduce((a, b) => a + b) / prices.length;
    double variance = prices.map((p) => pow(p - mean, 2)).reduce((a, b) => a + b) / prices.length;
    double std = sqrt(variance);

    return prices.where((price) {
      double zScore = (price - mean) / std;
      return zScore.abs() > threshold;
    }).toList();
  }

// IQR ile anomali tespiti
  List<double> detectAnomaliesWithIQR(List<double> prices) {
    List<double> sortedPrices = List.from(prices)..sort();
    double q1 = sortedPrices[(prices.length * 0.25).toInt()];
    double q3 = sortedPrices[(prices.length * 0.75).toInt()];
    double iqr = q3 - q1;

    double lowerBound = q1 - 1 * iqr;
    double upperBound = q3 + 1 * iqr;

    return prices.where((price) => price < lowerBound || price > upperBound).toList();
  }

// Kayar Pencere yöntemi ile anomali tespiti
  List<double> detectAnomaliesWithSlidingWindow(List<double> prices, int windowSize) {
    List<double> anomalies = [];
    for (int i = windowSize; i < prices.length; i++) {
      List<double> window = prices.sublist(i - windowSize, i);
      double localMean = window.reduce((a, b) => a + b) / window.length;
      double localVariance = window.map((p) => pow(p - localMean, 2)).reduce((a, b) => a + b) / window.length;
      double localStd = sqrt(localVariance);

      double lowerBound = localMean - 1.5 * localStd;
      double upperBound = localMean + 1.5 * localStd;

      if (prices[i] < lowerBound || prices[i] > upperBound) {
        anomalies.add(prices[i]);
      }
    }
    return anomalies;
  }

  List<double> detectCommonAnomalies(List<double> prices,
      {double zScoreThreshold = 2.5, int slidingWindowSize = 5}) {
    // Z-Score yöntemi
    List<double> anomaliesZScore = detectAnomaliesWithZScore(prices, zScoreThreshold);

    // IQR yöntemi
    List<double> anomaliesIQR = detectAnomaliesWithIQR(prices);

    // Kayar Pencere yöntemi
    List<double> anomaliesSlidingWindow = detectAnomaliesWithSlidingWindow(prices, slidingWindowSize);

    // Ortak noktaları bulma
    Set<double> commonAnomalies = Set<double>.from(anomaliesZScore)
        .intersection(Set<double>.from(anomaliesIQR))
        .intersection(Set<double>.from(anomaliesSlidingWindow));

    return commonAnomalies.toList();
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(' '),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: isLoading
                ? CircularProgressIndicator(color: Colors.white) // Yüklenirken dönen animasyon
                : Icon(Icons.refresh, color: Colors.white),
            onPressed: isLoading ? null : _fetchChartData, // Yükleme sırasında buton devre dışı
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'btcusdt',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              lastPrice != null ? '\$${lastPrice!.toStringAsFixed(2)}' : 'Loading...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              change != null ? '${change!.toStringAsFixed(2)} (${((change! / lastPrice!) * 100).toStringAsFixed(2)}%)' : '',
              style: TextStyle(
                color: change != null && change! >= 0 ? Colors.green : Colors.red,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            anomalies.isNotEmpty
                ? Text(
              'Anomalies detected: ${anomalies.length}',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            )
                : SizedBox(),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.white,
              tabs: ranges.map((range) => Tab(text: range.toUpperCase())).toList(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          // Main price chart
                          LineChartBarData(
                            spots: chartData[selectedRange]!.map((spot) {
                              final formattedY = double.parse(formatNumber(spot.y));
                              return FlSpot(spot.x, formattedY);
                            }).toList(),
                            isCurved: true,
                            colors: [Colors.greenAccent],
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              colors: [Colors.green.withOpacity(0.3)],
                            ),
                          ),
                          // Anomalies as dots on the chart
                          LineChartBarData(
                            spots: anomalies.map((anomaly) {
                              // Find the corresponding spot in the chart data
                              final spot = chartData[selectedRange]!.firstWhere(
                                    (s) => s.y == anomaly,
                                orElse: () => FlSpot(0, anomaly),
                              );
                              return spot;
                            }).toList(),
                            isCurved: false,
                            colors: [Colors.red], // Bu renk parametresi doğru kullanıldı.
                            dotData: FlDotData(show: true), // dotSize ve colors parametreleri burada kullanılmıyor
                            belowBarData: BarAreaData(show: false),
                          ),


                          // Bollinger Bands
                          if (showBollingerBands && calculateBollingerBands(chartData[selectedRange]!).isNotEmpty)
                            ...calculateBollingerBands(chartData[selectedRange]!).map((band) => LineChartBarData(
                              spots: band.map((spot) {
                                final formattedY = double.parse(formatNumber(spot.y));
                                return FlSpot(spot.x, formattedY);
                              }).toList(),
                              isCurved: true,
                              colors: [Colors.blue],
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(show: false),
                            )),
                          // Moving Averages
                          if (showMovingAverages && calculateMovingAverage(chartData[selectedRange]!).isNotEmpty)
                            LineChartBarData(
                              spots: calculateMovingAverage(chartData[selectedRange]!).map((spot) {
                                final formattedY = double.parse(formatNumber(spot.y));
                                return FlSpot(spot.x, formattedY);
                              }).toList(),
                              isCurved: true,
                              colors: [Colors.red],
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(show: false),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      backgroundColor: Colors.greenAccent,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenChart(
                              data: chartData[selectedRange] ?? [],
                              showRSI: showRSI,
                              showBollingerBands: showBollingerBands,
                              showMovingAverages: showMovingAverages,
                            ),
                          ),
                        );
                      },
                      child: Icon(Icons.fullscreen, color: Colors.white),
                    ),
                  ),
                  if (isLoading) CircularProgressIndicator(), // Display loading indicator
                ],
              ),
            ),

            // RSI Grafiği
    if (showRSI)
    SizedBox(
    height: MediaQuery.of(context).size.height * 0.2,
    child: LineChart(
    LineChartData(
    gridData: FlGridData(show: false),
    titlesData: FlTitlesData(show: false),
    borderData: FlBorderData(show: false),
    lineBarsData: [
    LineChartBarData(
    spots: calculateRSI(chartData[selectedRange]!),
    isCurved: true,
    colors: [Colors.orange],
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    ),
    ],
    ),
    ),
    ),
    SizedBox(height: 16),
    Text(
    'Price',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    SizedBox(height: 8),
    _buildPriceDetailRow('Last:', lastPrice),
    _buildPriceDetailRow('High:', highPrice),
    _buildPriceDetailRow('Low:', lowPrice),
    SizedBox(height: 16),
    Text(
    'Indicators',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    // RSI Switch
    SwitchListTile(
    title: Text('RSI (Relative Strength Index)', style: TextStyle(color: Colors.white)),
    value: showRSI,
    onChanged: (value) {
    setState(() {
    showRSI = value;
    });
    },
    ),
    // Bollinger Bands Switch
    SwitchListTile(
    title: Text('Bollinger Bands', style: TextStyle(color: Colors.white)),
    value: showBollingerBands,
    onChanged: (value) {
    setState(() {
    showBollingerBands = value;
    });
    },
    ),
    // Moving Averages Switch
    SwitchListTile(
    title: Text('Moving Averages', style: TextStyle(color: Colors.white)),
    value: showMovingAverages,
    onChanged: (value) {
    setState(() {
    showMovingAverages = value;
    });
    },
    ),
    ],
    ),
    ),
    ));
  }
  List<FlSpot> calculateRSI(List<FlSpot> data) {
    int period = 14; // RSI dönemi

    // Veri yetersizse boş liste döndür
    if (data.length < period) {
      print("RSI hesaplanamıyor: Yeterli veri yok");
      return [];
    }
//1
    List<double> gains = [];
    List<double> losses = [];

    // Fiyat değişimlerini hesaplayın
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

    // Ortalama kazanç ve kayıplar
    for (int i = 0; i < gains.length; i++) {
      if (i < period - 1) continue;

      double avgGain = gains.sublist(i - period + 1, i + 1).reduce((a, b) => a + b) / period;
      double avgLoss = losses.sublist(i - period + 1, i + 1).reduce((a, b) => a + b) / period;

      avgGains.add(avgGain);
      avgLosses.add(avgLoss);


      double currentRS = avgGain / (avgLoss == 0 ? 1 : avgLoss);
      rs.add(currentRS);

      double currentRSI = 100 - (100 / (1 + currentRS));
      rsi.add(currentRSI);
    }

    // RSI değerlerini FlSpot formatında döndürün
    List<FlSpot> rsiSpots = [];
    for (int i = 0; i < rsi.length; i++) {
      rsiSpots.add(FlSpot(data[i + period].x, rsi[i]));
    }

    return rsiSpots;
  }



  List<List<FlSpot>> calculateBollingerBands(List<FlSpot> data) {
    if (data.isEmpty) return [[], []];

    int period = 20; // Bollinger Bands dönemi
    List<FlSpot> upperBand = [];
    List<FlSpot> lowerBand = [];

    for (int i = 0; i < data.length; i++) {
      if (i < period - 1) continue;

      List<double> subset = data.sublist(i - period + 1, i + 1).map((spot) => spot.y).toList();
      double mean = subset.reduce((a, b) => a + b) / subset.length;
      double stdDev = sqrt(subset.map((value) => pow(value - mean, 2)).reduce((a, b) => a + b) / subset.length);

      upperBand.add(FlSpot(data[i].x, mean + 2 * stdDev));
      lowerBand.add(FlSpot(data[i].x, mean - 2 * stdDev));
    }

    return [upperBand, lowerBand];
  }

  List<FlSpot> calculateMovingAverage(List<FlSpot> data) {
    if (data.isEmpty) return [];

    int period = 20; // Hareketli Ortalama dönemi
    List<FlSpot> movingAverage = [];

    for (int i = 0; i < data.length; i++) {
      if (i < period - 1) continue;

      double average = data.sublist(i - period + 1, i + 1).map((spot) => spot.y).reduce((a, b) => a + b) / period;
      movingAverage.add(FlSpot(data[i].x, average));
    }

    return movingAverage;
  }






  Widget _buildPriceDetailRow(String label, double? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey)),
        Text(
          value != null ? value.toStringAsFixed(2) : '...',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Future<Map<String, List<FlSpot>>> fetchCryptoChartData(String range) async {
    String days = _convertRangeToDays(range);
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=usd&days=$days'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> prices = data['prices'];

      if (prices.isEmpty) {
        throw Exception('Seçilen zaman aralığı için veri bulunamadı.');
      }

      List<FlSpot> spots = [];
      for (var price in prices) {
        var timestamp = DateTime.fromMillisecondsSinceEpoch(price[0].toInt()).millisecondsSinceEpoch / 1000;
        var value = price[1].toDouble();
        spots.add(FlSpot(timestamp.toDouble(), value));
      }

      return {
        range: spots,
      };
    } else {
      throw Exception('Grafik verisi alınırken hata oluştu');
    }
  }

  String _convertRangeToDays(String range) {
    const ranges = {
      '10m': '0.0069',
      '30m': '0.0208',
      '1h': '0.0417',
      '4h': '0.167',
      '24h': '1',
      '7d': '7',
      '1m': '30',
    };
    return ranges[range] ?? '1';
  }
}
