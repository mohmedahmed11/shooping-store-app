import 'package:flutter/foundation.dart';
import 'package:marka_app/Data/Models/ProductModel.dart';

class Cart with ChangeNotifier {
  List<Product> products;
  Cart(this.products);
  double get total {
    return products.fold(0.0, (double currentTotal, Product nextProduct) {
      return currentTotal + (nextProduct.price * nextProduct.count);
    });
  }

  double delivaryCost = 1500;

  double get finalTotal {
    return total + delivaryCost;
  }

  void addToCart(Product product) async {
    if (products.where((item) => item.id == product.id).isEmpty) {
      products.add(product);
    }
  }

  void removeFromCart(Product product) {
    products.remove(product);
    notifyListeners();
  }
}
