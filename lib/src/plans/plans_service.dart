import 'package:shared_preferences/shared_preferences.dart';

/// A service that handles In App Purchases.
class PlansService {

  Future<String?> getPurchasedProductID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('productID');
  }

  Future<void> cancelPurchasedProductID() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('productID');
  }

  Future<void> _ensureAvailability() async {
    // final bool available = await InAppPurchase.instance.isAvailable();
    // if (!available) {
      print("ERROR: IAP not available.");
    // }
  }

  /// Restore previous purchases.
  Future<void> restorePurchase() async {
    await _ensureAvailability();
    // await InAppPurchase.instance.restorePurchases();
    print("Restoring purchases of product");
  }

  Future<void> purchase(String productID) async {
    await _ensureAvailability();
    // PurchaseDetails purchase = PurchaseDetails(productID: planName, verificationData: null, transactionDate: DateTime(), status: PurchaseStatus.pending);
    // await InAppPurchase.instance.completePurchase(purchase);
    // final ProductDetails productDetails = ... // Saved earlier from queryProductDetails().
    // final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    // if (_isConsumable(productDetails)) {
    //   InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
    // } else {
    //   InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    // }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('productID', productID);
    print('Purchase of product ${productID}');
  }
}
