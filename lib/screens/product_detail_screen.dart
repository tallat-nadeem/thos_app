import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../services/cart_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List<Product> related = [];

  @override
  void initState() {
    super.initState();
    loadRelated();
  }

  void loadRelated() async {
    final data = await ProductService.fetchProducts(
      1,
      categoryId: widget.product.categoryId,
    );

    setState(() {
      related = data;
    });
  }

  void addToCart(Product product) {
    CartService.addToCart(product);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Added to Cart"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(p.name),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔥 IMAGE
            Image.network(
              p.image,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 10),

            // 💰 PRICE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Rs ${p.price}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 📄 DESCRIPTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                p.description,
                style: const TextStyle(fontSize: 14),
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 ADD TO CART BUTTON
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => addToCart(p),
                child: const Text("Add to Cart"),
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 RELATED PRODUCTS TITLE
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Related Products",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 🔥 RELATED PRODUCTS LIST
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: related.length,
                itemBuilder: (context, i) {
                  final item = related[i];

                  return Container(
                    width: 150,
                    margin: const EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              item.image,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        Text(
                          "Rs ${item.price}",
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}