import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/cart_model.dart';
import '../services/cart_service.dart';
import '../widgets/product_image.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Detail"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: 250,
                  child: ProductImage(imageUrl: product.image),
                ),

                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    product.name,
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Rs ${product.price}",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // 🔥 ADD TO CART BUTTON
          Padding(
            padding: EdgeInsets.all(12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                CartService.addToCart(
                  CartItem(
                    id: product.id,
                    name: product.name,
                    price: product.price,
                    image: product.image,
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Added to Cart"),
                  ),
                );
              },
              child: Text("Add to Cart"),
            ),
          ),
        ],
      ),
    );
  }
}