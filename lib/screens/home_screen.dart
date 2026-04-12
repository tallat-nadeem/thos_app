import 'package:flutter/material.dart';
import 'products_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: SafeArea(
        child: Column(
          children: [

            // 🔍 SEARCH BAR
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.pink),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text("Search Products...",
                        style: TextStyle(color: Colors.grey)),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Search",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),

            // 🔥 CATEGORY TABS (Daraz Style)
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  TabItem(title: "Reels"),
                  TabItem(title: "For You"),
                  TabItem(title: "Free Delivery"),
                  TabItem(title: "New"),
                  TabItem(title: "Trending"),
                ],
              ),
            ),

            // 🔥 PRODUCTS
            const Expanded(
              child: ProductsScreen(),
            )
          ],
        ),
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final String title;

  const TabItem({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.orange, width: 2),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13),
        ),
      ),
    );
  }
}