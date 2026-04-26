import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ✅ NEW API KEYS (UPDATED)
const String baseUrl = "https://tallatherbs.com";
const String consumerKey = "ck_f9144c31d3ab6ca0ec165697a683319b6fb7019d";
const String consumerSecret = "cs_f4abcecb6c99b76d348f22c520160ce25480cd81";

void main() {
  runApp(const ThosApp());
}

class ThosApp extends StatelessWidget {
  const ThosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      theme: ThemeData.dark(),
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
  List<Map> cart = [];

  int page = 1;
  bool isLoading = false;
  bool hasMore = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        fetchProducts();
      }
    });
  }

  // 🔥 FIXED API CALL (HEADER AUTH)
  Future fetchProducts() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    final url =
        "$baseUrl/wp-json/wc/v3/products?page=$page&per_page=10";

    String basicAuth = 'Basic ' +
        base64Encode(utf8.encode('$consumerKey:$consumerSecret'));

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": basicAuth,
        },
      );

      print("STATUS: ${response.statusCode}");

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        if (data.isEmpty) {
          hasMore = false;
        } else {
          setState(() {
            products.addAll(data);
            page++;
          });
        }
      } else {
        print("ERROR: ${response.body}");
      }
    } catch (e) {
      print("ERROR: $e");
    }

    setState(() => isLoading = false);
  }

  // 🛒 ADD TO CART
  void addToCart(product) {
    int index = cart.indexWhere((e) => e["id"] == product["id"]);

    setState(() {
      if (index != -1) {
        cart[index]["qty"] += 1;
      } else {
        cart.add({...product, "qty": 1});
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to Cart")),
    );
  }

  Widget topIcon(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1C),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Text("THOS"),
            const Spacer(),

            topIcon(Icons.store),
            topIcon(Icons.video_collection),
            topIcon(Icons.account_balance_wallet),

            topIcon(Icons.shopping_cart, onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cart: cart),
                ),
              );
            }),

            topIcon(Icons.person),
            const SizedBox(width: 6),
            Image.asset("assets/thos_logo.png", height: 26),
          ],
        ),
      ),

      body: products.isEmpty && isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: products.length + 1,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                if (index == products.length) {
                  return isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox();
                }

                final product = products[index];

                String imageUrl = "";
                if (product["images"] != null &&
                    product["images"].isNotEmpty) {
                  imageUrl = product["images"][0]["src"];
                }

                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                            : const Icon(Icons.image),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          children: [
                            Text(
                              product["name"] ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "Rs ${product["price"] ?? "0"}",
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 6),

                            ElevatedButton(
                              onPressed: () => addToCart(product),
                              child: const Text("Add"),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// ================= CART =================

class CartScreen extends StatefulWidget {
  final List<Map> cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  double total() {
    double t = 0;
    for (var item in widget.cart) {
      t += (double.tryParse(item["price"].toString()) ?? 0) *
          item["qty"];
    }
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),

      body: widget.cart.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Column(
              children: [

                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cart.length,
                    itemBuilder: (context, index) {
                      final item = widget.cart[index];

                      String imageUrl = "";
                      if (item["images"] != null &&
                          item["images"].isNotEmpty) {
                        imageUrl = item["images"][0]["src"];
                      }

                      return ListTile(
                        leading: imageUrl.isNotEmpty
                            ? Image.network(imageUrl, width: 50)
                            : null,

                        title: Text(item["name"]),
                        subtitle: Text("Rs ${item["price"]}"),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (item["qty"] > 1) item["qty"]--;
                                });
                              },
                            ),

                            Text("${item["qty"]}"),

                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  item["qty"]++;
                                });
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  widget.cart.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text("Total: Rs ${total()}"),

                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("Checkout"),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}