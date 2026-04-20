import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

// 🔐 API
const String baseUrl = "https://tallatherbs.com";
const String consumerKey = "ck_d013d276953f4d24bcc56c95d9d236009eb4eecd";
const String consumerSecret = "cs_d74dd959ea68444b8302c1ca2ab505cfef9e89aa";

void main() {
  runApp(ThosApp());
}

class ThosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'THOS',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
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

  Future fetchProducts() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    final url =
        "$baseUrl/wp-json/wc/v3/products?consumer_key=$consumerKey&consumer_secret=$consumerSecret&page=$page&per_page=10";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      setState(() {
        products.addAll(data);
        page++;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  // 🔥 WEBSITE OPEN FUNCTION
  void openWebsite(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F172A),

      // 🔥 APP BAR (ALL BUTTONS)
      appBar: AppBar(
        title: Text("THOS"),
        actions: [

          IconButton(
            icon: Icon(Icons.store),
            onPressed: () {},
          ),

          IconButton(
            icon: Icon(Icons.videogame_asset),
            onPressed: () {},
          ),

          IconButton(
            icon: Icon(Icons.account_balance_wallet),
            onPressed: () {},
          ),

          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              openWebsite("$baseUrl/cart");
            },
          ),

          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {},
          ),

          SizedBox(width: 10)
        ],
      ),

      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels ==
              scrollInfo.metrics.maxScrollExtent) {
            fetchProducts();
          }
          return true;
        },

        child: GridView.builder(
          padding: EdgeInsets.all(10),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75, // 🔥 FIXED SIZE
          ),

          itemBuilder: (context, index) {

            final p = products[index];

            // 🔥 SAFE IMAGE FIX
            String imageUrl = "";
            if (p["images"] != null && p["images"].length > 0) {
              imageUrl = p["images"][0]["src"];
            }

            return GestureDetector(
              onTap: () {
                openWebsite(p["permalink"]); // 🔥 product page open
              },

              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Column(
                  children: [

                    // 🖼 IMAGE
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15)),
                        child: imageUrl != ""
                            ? Image.network(
                                imageUrl,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(color: Colors.black),
                      ),
                    ),

                    // 📝 DETAILS
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        children: [

                          Text(
                            p["name"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: 4),

                          Text(
                            "Rs ${p["price"]}",
                            style: TextStyle(
                                color: Colors.yellowAccent,
                                fontWeight: FontWeight.bold),
                          ),

                          SizedBox(height: 5),

                          // 🔥 ADD TO CART → WEBSITE
                          ElevatedButton(
                            onPressed: () {
                              openWebsite("$baseUrl/product/${p["slug"]}");
                            },
                            child: Text("Buy Now"),
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