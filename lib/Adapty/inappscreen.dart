import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:yeniproje/Adapty/main.dart';


class InAppScreen extends StatefulWidget {
  const InAppScreen({Key? key}) : super(key: key);

  @override
  State<InAppScreen> createState() => _InAppScreenState();
}

class _InAppScreenState extends State<InAppScreen> {
  late final InAppPurchase _inAppPurchase;
  late final ProductDetails _productDetails;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    super.initState();
    _inAppPurchase = InAppPurchase.instance;
    _loadProducts();

    // Purchase updates stream (ödeme durumu kontrolü)
    _subscription = _inAppPurchase.purchaseStream.listen(
          (purchaseDetailsList) {
        for (var purchaseDetails in purchaseDetailsList) {
          _handlePaymentStatus(purchaseDetails);
        }
      },
      onError: (error) {
        print("Error: $error");
      },
    );

  }

  // Ürünleri yükleme
  void _loadProducts() async {
    const Set<String> _kIds = {'com.yourcompany.adapty.monthly'}; // Ödeme ürünü ID'si
    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(_kIds);
    if (response.notFoundIDs.isEmpty) {
      _productDetails = response.productDetails.first;
    } else {
      // Hata: Ürünler bulunamadı
    }
  }

  // Ödeme işlemi
  void _buyProduct() async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: _productDetails);
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  // Ödeme başarı durumu
  void _handlePaymentStatus(PurchaseDetails purchaseDetails) {
    if (purchaseDetails.status == PurchaseStatus.purchased) {
      // Satın alma başarılı
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Payment Completed"),
          content: const Text("Your payment was successful."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else if (purchaseDetails.status == PurchaseStatus.error ||
        purchaseDetails.status == PurchaseStatus.canceled) {
      // Satın alma başarısız ya da kullanıcı tarafından iptal edildi
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Payment Failed"),
          content: const Text("Your payment has not been made."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }


  // Restore Purchase işlemi
  void _restorePurchase() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      // Hata durumunda yapılacak işlemler
      print('Restore purchase failed: $e');
    }
  }


  @override
  void dispose() {
    _subscription.cancel(); // Dinleyiciyi temizle
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Adapty - InApp Purchase")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Per Month Price \$19.99"),
            ElevatedButton(
              onPressed: _buyProduct,
              child: const Text("Buy"),
            ),
            ElevatedButton(
              onPressed: _restorePurchase,
              child: const Text("Restore Purchase"),
            ),
          ],
        ),
      ),
    );
  }
}
