import '../models/product_model.dart';

class CartService {
  static final List<Product> _cartItems = [];

  // ➕ ADD TO CART
  static void addToCart(Product product) {
    _cartItems.add(product);
  }

  // ❌ REMOVE ITEM
  static void removeFromCart(Product product) {
    _cartItems.remove(product);
  }

  // 📦 GET ITEMS
  static List<Product> getCartItems() {
    return _cartItems;
  }

  // 🧹 CLEAR CART
  static void clearCart() {
    _cartItems.clear();
  }

  // 💰 TOTAL PRICE
  static double getTotalPrice() {
    double total = 0;

    for (var item in _cartItems) {
      total += double.tryParse(item.price) ?? 0;
    }

    return total;
  }
}