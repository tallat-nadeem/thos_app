import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../models/product_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  Widget build(BuildContext context) {
    List<Product> items = CartService.getCartItems();

    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),

      body: items.isEmpty
          ? const Center(child: Text("Cart is Empty"))
          : Column(
              children: [

                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return ListTile(
                        leading: Image.network(item.image, width: 50),
                        title: Text(item.name),
                        subtitle: Text("Rs ${item.price}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            CartService.removeFromCart(item);
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
                ),

                // 💰 TOTAL
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Total: Rs ${CartService.getTotalPrice()}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // 🔥 CHECKOUT BUTTON
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Order Placed (Demo)"),
                        ),
                      );

                      CartService.clearCart();
                      setState(() {});
                    },
                    child: const Text("Checkout"),
                  ),
                )
              ],
            ),
    );
  }
}