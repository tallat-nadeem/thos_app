import '../models/cart_model.dart';

class CartService {
  static List<CartItem> cartItems = [];

  static void addToCart(CartItem item) {
    int index = cartItems.indexWhere((e) => e.id == item.id);

    if (index != -1) {
      cartItems[index].quantity++;
    } else {
      cartItems.add(item);
    }
  }

  static void increaseQty(int id) {
    int index = cartItems.indexWhere((e) => e.id == id);
    if (index != -1) {
      cartItems[index].quantity++;
    }
  }

  static void decreaseQty(int id) {
    int index = cartItems.indexWhere((e) => e.id == id);
    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      } else {
        cartItems.removeAt(index);
      }
    }
  }

  static double getTotal() {
    double total = 0;

    for (var item in cartItems) {
      double price = double.tryParse(item.price) ?? 0;
      total += price * item.quantity;
    }

    return total;
  }

  static List<CartItem> getCart() {
    return cartItems;
  }
}