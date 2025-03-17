import 'package:flutter/material.dart';
import 'package:cryptofont/cryptofont.dart'; // Paket importu
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

import 'BitcoinScreen.dart';





class PortfolioScreen extends StatefulWidget {
  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  Map<String, Map<String, dynamic>>? cryptoData;
  Map<String, List<FlSpot>>? chartData;
  final List<String> coinIds = [
    'bitcoin',
    'ethereum',
    'tether',
    'binancecoin',
    'solana',
    'ripple',
    'dogecoin',
    'tron',
    'usd-coin',
    'avalanche-2',
    'shiba-inu',
    'weth',
    'pepe',
    'monero'
  ];
  String? topGainerCoin;

  @override
  void initState() {
    super.initState();
    _getCryptoData();
  }

  Future<void> _getCryptoData() async {
    try {
      Map<String, Map<String, dynamic>> data = await fetchCryptoData();
      String? topGainer = _findTopGainer(data);
      Map<String, List<FlSpot>> charts = {};

      if (topGainer != null) {
        charts = await fetchCryptoChartData(topGainer);
      }
      setState(() {
        cryptoData = data;
        topGainerCoin = topGainer;
        chartData = charts;
      });
    } catch (e) {
      print("Hata: $e");
      setState(() {
        cryptoData = {};
        topGainerCoin = null;
        chartData = {};
      });
    }
  }

  String? _findTopGainer(Map<String, Map<String, dynamic>> data) {
    String? topGainer;
    double maxChange = double.negativeInfinity;

    for (var entry in data.entries) {
      if (entry.value['percentage_change'] > maxChange) {
        maxChange = entry.value['percentage_change'];
        topGainer = entry.key;
      }
    }

    return topGainer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Text(
          'Portfolio',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Bildirimler tıklaması
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: Text(
                'Menü',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Home tıklaması
              },
            ),
            // Diğer menü öğeleri...
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 3.85,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF08AEEA), Color(0xFF2AF598)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: topGainerCoin != null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Top Gainer: ${_getNameForCoin(topGainerCoin!)}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: chartData?[topGainerCoin] ?? [],
                              isCurved: true,
                              colors: [Colors.blue],
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
                    : Center(
                  child: Text(
                    'No Data',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Coins',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.separated(
                        itemCount: coinIds.length,
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.white,
                          thickness: 2,
                        ),
                        itemBuilder: (context, index) {
                          String coinId = coinIds[index];
                          return _buildCryptoListItem(
                            icon: _getIconForCoin(coinId),
                            color: _getColorForCoin(coinId),
                            name: _getNameForCoin(coinId),
                            price: cryptoData?[coinId]?['price'],
                            percentageChange:
                            cryptoData?[coinId]?['percentage_change'],

                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildCryptoListItem({
    IconData? icon,
    Color? color,
    String? name,
    double? price,
    double? percentageChange,
    VoidCallback? onTap,
  }) {
    IconData changeIcon = percentageChange != null
        ? (percentageChange >= 0 ? Icons.trending_up : Icons.trending_down)
        : Icons.help;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(
          icon,
          color: color,
          size: 40,
        ),
      ),
      title: Text(
        name ?? '',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              price != null ? '\$${price.toStringAsFixed(2)}' : 'Loading...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  percentageChange != null
                      ? '${percentageChange.toStringAsFixed(2)}%'
                      : 'Loading...',
                  style: TextStyle(
                    color: percentageChange != null && percentageChange >= 0
                        ? Colors.green
                        : Colors.red,
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  changeIcon,
                  color: percentageChange != null && percentageChange >= 0
                      ? Colors.green
                      : Colors.red,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        // Navigate to the BitcoinScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BitcoinScreen(),
          ),
        );
      },

    );
  }

  IconData _getIconForCoin(String coinId) {
    switch (coinId) {
      case 'bitcoin':
        return CryptoFontIcons.btc;
      case 'ethereum':
        return CryptoFontIcons.eth;
      case 'tether':
        return CryptoFontIcons.usdt;
      case 'binancecoin':
        return CryptoFontIcons.bnb;
      case 'solana':
        return CryptoFontIcons.sol;
      case 'ripple':
        return CryptoFontIcons.xrp;
      case 'dogecoin':
        return CryptoFontIcons.doge;
      case 'tron':
        return CryptoFontIcons.trx;
      case 'usd-coin':
        return CryptoFontIcons.usdc;
      case 'avalanche-2':
        return CryptoFontIcons.avax;
      case 'shiba-inu':
        return Icons.pets;
      case 'weth':
        return Icons.attach_money;
      case 'pepe':
        return Icons.star;
      case 'monero':
        return CryptoFontIcons.xmr;
      default:
        return Icons.help;
    }
  }

  Color _getColorForCoin(String coinId) {
    switch (coinId) {
      case 'bitcoin':
        return Color(0xFFF5B300);
      case 'ethereum':
        return Color(0xFF627EEA);
      case 'tether':
        return Color(0xFF26A17B);
      case 'binancecoin':
        return Color(0xFFFFC107);
      case 'solana':
        return Color(0xFF4FC3F7);
      case 'ripple':
        return Color(0xFF00A6A6);
      case 'dogecoin':
        return Color(0xFFFFCC00);
      case 'tron':
        return Color(0xFFE94D3C);
      case 'usd-coin':
        return Color(0xFF2775CA);
      case 'avalanche-2':
        return Color(0xFFE84142);
      case 'shiba-inu':
        return Color(0xFFE8741A);
      case 'weth':
        return Color(0xFF646FD4);
      case 'pepe':
        return Color(0xFF00A9E0);
      case 'monero':
        return Color(0xFFFF6600);
      default:
        return Colors.grey;
    }
  }

  String _getNameForCoin(String coinId) {
    switch (coinId) {
      case 'bitcoin':
        return 'Bitcoin';
      case 'ethereum':
        return 'Ethereum';
      case 'tether':
        return 'Tether (USDT)';
      case 'binancecoin':
        return 'BNB';
      case 'solana':
        return 'Solana';
      case 'ripple':
        return 'XRP';
      case 'dogecoin':
        return 'Dogecoin';
      case 'tron':
        return 'TRON';
      case 'usd-coin':
        return 'USDC';
      case 'avalanche-2':
        return 'Avalanche';
      case 'shiba-inu':
        return 'Shiba Inu';
      case 'weth':
        return 'WETH';
      case 'pepe':
        return 'Pepe';
      case 'monero':
        return 'Monero';
      default:
        return 'Unknown';
    }
  }
}

Future<Map<String, Map<String, dynamic>>> fetchCryptoData() async {
  final response = await http.get(Uri.parse(
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin,ethereum,tether,binancecoin,solana,ripple,dogecoin,tron,usd-coin,avalanche-2,shiba-inu,weth,pepe,monero&price_change_percentage=1d'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return Map.fromIterable(
      data,
      key: (item) => item['id'] as String,
      value: (item) => {
        'price': (item['current_price'] as num).toDouble(),
        'percentage_change': (item['price_change_percentage_24h'] as num)
            .toDouble(),
      },
    );
  } else {
    throw Exception('Failed to load crypto data');
  }
}

Future<Map<String, List<FlSpot>>> fetchCryptoChartData(String coinId) async {
  final response = await http.get(Uri.parse(
      'https://api.coingecko.com/api/v3/coins/$coinId/market_chart?vs_currency=usd&days=1'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List<dynamic> prices = data['prices'];

    List<FlSpot> spots = [];
    for (var price in prices) {
      var timestamp = DateTime.fromMillisecondsSinceEpoch(price[0].toInt())
          .millisecondsSinceEpoch /
          1000;
      var value = price[1].toDouble();
      spots.add(FlSpot(timestamp.toDouble(), value));
    }

    return {
      coinId: spots,
    };
  } else {
    throw Exception('Failed to load chart data');
  }
}


