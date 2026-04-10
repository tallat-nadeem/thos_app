import 'package:flutter/material.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatelessWidget {

  final List<Map<String, dynamic>> products = [
    {
      "name": "Gluta White Cream",
      "price": "1500",
      "short_description": "Skin whitening & glow cream",
      "images": [
        {
          "src": "https://via.placeholder.com/300"
        }
      ]
    },
    {
      "name": "Hair Oil",
      "price": "800",
      "short_description": "Stops hair fall & boosts growth",
      "images": [
        {
          "src": "https://via.placeholder.com/300"
        }
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("THOS Products"),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {

          final product = products[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailScreen(product: product),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.all(10),
              elevation: 5,
              child: Row(
                children: [
                  Image.network(
                    product['images'][0]['src'],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            product['name'],
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),

                          SizedBox(height: 5),

                          Text(
                            "Rs ${product['price']}",
                            style: TextStyle(color: Colors.green),
                          ),

                          SizedBox(height: 5),

                          Text(
                            product['short_description'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}