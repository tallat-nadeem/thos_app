import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../widgets/product_image.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartService.getCart();

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: cart.isEmpty
          ? Center(child: Text("Cart is Empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];

                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading: ProductImage(imageUrl: item.image),
                          title: Text(item.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Rs ${item.price}"),
                              SizedBox(height: 5),

                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_circle,
                                        color: Colors.red),
                                    onPressed: () {
                                      CartService.decreaseQty(item.id);
                                      refresh();
                                    },
                                  ),
                                  Text("${item.quantity}"),
                                  IconButton(
                                    icon: Icon(Icons.add_circle,
                                        color: Colors.green),
                                    onPressed: () {
                                      CartService.increaseQty(item.id);
                                      refresh();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(15),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Rs ${CartService.getTotal().toStringAsFixed(0)}",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}