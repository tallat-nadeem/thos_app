import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

// 🔐 API
const String baseUrl = "https://tallatherbs.com";
const String consumerKey = "ck_d013d276953f4d24bcc56c95d9d236009eb4eecd";
const String consumerSecret = "cs_d74dd959ea68444b8302c1ca2ab505cfef9e89aa";

void main() {
  runApp(const ThosApp());
}

class ThosApp extends StatelessWidget {
  const ThosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'THOS',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List products = [];
  int page = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      final url =
          "$baseUrl/wp-json/wc/v3/products?consumer_key=$consumerKey&consumer_secret=$consumerSecret&page=$page&per_page=10";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        setState(() {
          products.addAll(data);
          page++;
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    setState(() => isLoading = false);
  }

  // 🌐 OPEN WEBSITE
  Future<void> openWebsite(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("THOS"),
        actions: [
          IconButton(icon: const Icon(Icons.store), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videogame_asset), onPressed: () {}),
          IconButton(icon: const Icon(Icons.account_balance_wallet), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              openWebsite("$baseUrl/cart");
            },
          ),
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
          const SizedBox(width: 10),
        ],
      ),

      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!isLoading &&
              scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
            fetchProducts();
          }
          return true;
        },

        child: GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.70, // 🔥 better spacing
          ),

          itemBuilder: (context, index) {
            final p = products[index];

            String imageUrl = "";
            if (p["images"] != null &&
                p["images"] is List &&
                p["images"].isNotEmpty) {
              imageUrl = p["images"][0]["src"] ?? "";
            }

            return GestureDetector(
              onTap: () {
                openWebsite(p["permalink"] ?? baseUrl);
              },

              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Column(
                  children: [

                    // 🖼 IMAGE
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15)),
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image, size: 50),
                              )
                            : const Icon(Icons.image, size: 50),
                      ),
                    ),

                    // 📦 DETAILS
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        children: [

                          Text(
                            p["name"] ?? "No Name",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 4),

                          Text(
                            "Rs ${p["price"] ?? "0"}",
                            style: const TextStyle(
                              color: Colors.yellowAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          SizedBox(
                            width: double.infinity,
                            height: 35,
                            child: ElevatedButton(
                              onPressed: () {
                                openWebsite("$baseUrl/product/${p["slug"]}");
                              },
                              child: const Text("Buy Now"),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}