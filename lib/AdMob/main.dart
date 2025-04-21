import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();  // Reklam SDK'sını başlatma
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdMob Ads Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdScreen(),
    );
  }
}

class AdScreen extends StatefulWidget {
  @override
  _AdScreenState createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  late BannerAd _bannerAd;
  late InterstitialAd _interstitialAd;
  late RewardedAd _rewardedAd;
  bool _isBannerAdLoaded = false;
  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;
  bool _isLoading = false;

  // Test reklam ID'leri
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111'; // Banner Ad
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712'; // Interstitial Ad
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917'; // Rewarded Ad

  Future<void> _loadBannerAd() async {
    try {
      setState(() {
        _isLoading = true;
      });

      _bannerAd = BannerAd(
        adUnitId: bannerAdUnitId,
        size: AdSize.banner,
        request: AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            setState(() {
              _isBannerAdLoaded = true;
              _isLoading = false;
            });
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            setState(() {
              _isLoading = false;
            });
            ad.dispose();
          },
        ),
      )..load();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading banner ad: $e');
    }
  }

  Future<void> _loadInterstitialAd() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await InterstitialAd.load(
        adUnitId: interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            setState(() {
              _isInterstitialAdLoaded = true;
              _isLoading = false;
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            setState(() {
              _isLoading = false;
            });
            print('InterstitialAd failed to load: $error');
          },
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading interstitial ad: $e');
    }
  }

  Future<void> _loadRewardedAd() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await RewardedAd.load(
        adUnitId: rewardedAdUnitId,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            setState(() {
              _isRewardedAdLoaded = true;
              _isLoading = false;
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            setState(() {
              _isLoading = false;
            });
            print('RewardedAd failed to load: $error');
          },
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading rewarded ad: $e');
    }
  }

  void _showInterstitialAd() {
    if (_isInterstitialAdLoaded) {
      _interstitialAd.show();
    } else {
      print('Interstitial ad not loaded yet.');
    }
  }

  void _showRewardedAd() {
    if (_isRewardedAdLoaded) {
      _rewardedAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('User earned reward: ${reward.amount}');
        },
      );
    } else {
      print('Rewarded ad not loaded yet.');
    }
  }

  @override
  void initState() {
    super.initState();
    // Yalnızca bir reklamın yüklenmesine başlamak, diğer reklamları sırayla yüklemek
    _loadBannerAd();
    _loadInterstitialAd();
    _loadRewardedAd();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    if (_isInterstitialAdLoaded) {
      _interstitialAd.dispose();
    }
    if (_isRewardedAdLoaded) {
      _rewardedAd.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AdMob Ads Example')),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isBannerAdLoaded)
              SizedBox(
                height: _bannerAd.size.height.toDouble(),
                width: _bannerAd.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showInterstitialAd,
              child: Text('Show Interstitial Ad'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showRewardedAd,
              child: Text('Show Rewarded Ad'),
            ),
          ],
        ),
      ),
    );
  }
}
