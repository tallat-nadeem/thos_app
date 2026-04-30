import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ================= API =================
const String baseUrl = "https://tallatherbs.com";
const String consumerKey = "ck_f9144c31d3ab6ca0ec165697a683319b6fb7019d";
const String consumerSecret = "cs_f4abcecb6c99b76d348f22c520160ce25480cd81";

void main() {
  runApp(const ThosApp());
}

// ================= APP =================
class ThosApp extends StatelessWidget {
  const ThosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MainScreen(),
    );
  }
}

// ================= MAIN =================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int index = 0;
  List<Map> cart = [];

  @override
  Widget build(BuildContext context) {

    final pages = [
      HomeScreen(cart: cart),
      const ReelsScreen(),
      const WalletScreen(),
      CartScreen(cart: cart),
      const UserScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1C),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Text("THOS"),
            const Spacer(),

            IconButton(
              icon: const Icon(Icons.store),
              onPressed: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (_)=>MarketScreen())
                );
              },
            ),

            IconButton(
              icon: const Icon(Icons.video_collection),
              onPressed: ()=>setState(()=>index=1),
            ),

            IconButton(
              icon: const Icon(Icons.account_balance_wallet),
              onPressed: ()=>setState(()=>index=2),
            ),

            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: ()=>setState(()=>index=3),
            ),

            IconButton(
              icon: const Icon(Icons.person),
              onPressed: ()=>setState(()=>index=4),
            ),
          ],
        ),
      ),

      body: pages[index],
    );
  }
}

// ================= HOME (PRODUCTS) =================
class HomeScreen extends StatefulWidget {
  final List<Map> cart;
  const HomeScreen({super.key, required this.cart});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List products = [];
  int page = 1;
  bool loading = false;
  bool hasMore = true;

  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchProducts();

    controller.addListener(() {
      if (controller.position.pixels >=
          controller.position.maxScrollExtent - 200 &&
          !loading && hasMore) {
        fetchProducts();
      }
    });
  }

  Future fetchProducts() async {

    if (loading || !hasMore) return;
    loading = true;

    String auth = 'Basic ' +
        base64Encode(utf8.encode('$consumerKey:$consumerSecret'));

    final res = await http.get(
      Uri.parse("$baseUrl/wp-json/wc/v3/products?page=$page&per_page=10"),
      headers: {"Authorization": auth},
    );

    if (res.statusCode == 200) {
      List data = jsonDecode(res.body);

      if (data.isEmpty) {
        hasMore = false;
      } else {
        setState(() {
          products.addAll(data);
          page++;
        });
      }
    }

    loading = false;
  }

  void addToCart(product) {
    int i = widget.cart.indexWhere((e)=>e["id"]==product["id"]);

    setState(() {
      if(i!=-1){
        widget.cart[i]["qty"]++;
      } else {
        widget.cart.add({...product,"qty":1});
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      controller: controller,
      padding: const EdgeInsets.all(8),
      itemCount: products.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (_, i){

        if(i==products.length){
          return loading
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox();
        }

        var p = products[i];
        String img = p["images"].isNotEmpty ? p["images"][0]["src"] : "";

        return Card(
          child: Column(
            children: [
              Expanded(child: Image.network(img, fit: BoxFit.cover)),
              Text(p["name"], maxLines: 2),
              Text("Rs ${p["price"]}"),
              ElevatedButton(
                onPressed: ()=>addToCart(p),
                child: const Text("Add"),
              )
            ],
          ),
        );
      },
    );
  }
}

// ================= MARKETPLACE =================
class MarketScreen extends StatelessWidget {

  final Map<String, dynamic> categories = {

    "Electronics": {
      "Mobiles": ["Android", "iPhone"],
      "Laptops": ["Gaming", "Office"],
      "Solar": {
        "New Panels": ["Longi", "JA Solar"],
        "Used Panels": ["Working Panels"]
      },
      "Home Electronics": ["Fans", "AC", "Fridge"]
    },

    "Fashion": {
      "Men": ["Clothes", "Shoes"],
      "Women": {
        "Boutique": {
          "Fozia Signatures": ["Ready Made", "Custom Stitching"]
        }
      },
      "Kids": ["Boys Wear", "Girls Wear"]
    },

    "Household": {
      "Furniture": ["Beds", "Sofas"],
      "Kitchen": ["Utensils"]
    },

    "Agriculture": {
      "Machines": ["Harvesters"],
      "Tools": ["Sprayers"]
    },

    "Robots": {
      "Industrial": ["Automation"],
      "Home Robots": ["Cleaning Robot"]
    },

  };

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Marketplace")),

      body: ListView(
        children: categories.keys.map((cat){

          return ExpansionTile(
            title: Text(cat),
            children: buildSub(context, categories[cat]),
          );

        }).toList(),
      ),
    );
  }

  List<Widget> buildSub(BuildContext context, dynamic data){

    if(data is List){
      return data.map<Widget>((e){
        return ListTile(
          title: Text(e),
          onTap: (){
            Navigator.push(context,
              MaterialPageRoute(
                builder: (_)=>ComingSoonScreen(title: e)
              )
            );
          },
        );
      }).toList();
    }

    if(data is Map){
      return data.keys.map<Widget>((key){
        return ExpansionTile(
          title: Text(key),
          children: buildSub(context, data[key]),
        );
      }).toList();
    }

    return [];
  }
}

// ================= COMING SOON =================
class ComingSoonScreen extends StatelessWidget {
  final String title;
  const ComingSoonScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: Text(
          "Coming Soon",
          style: TextStyle(fontSize: 30),
        ),
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

  double total(){
    double t=0;
    for(var i in widget.cart){
      t += (double.tryParse(i["price"].toString())??0)*i["qty"];
    }
    return t;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),

      body: widget.cart.isEmpty
          ? const Center(child: Text("Empty"))
          : Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (_,i){

                var item = widget.cart[i];

                return ListTile(
                  title: Text(item["name"]),
                  subtitle: Text("Rs ${item["price"]}"),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: (){
                          setState(() {
                            if(item["qty"]>1) item["qty"]--;
                          });
                        },
                      ),

                      Text("${item["qty"]}"),

                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: (){
                          setState(()=>item["qty"]++);
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: (){
                          setState(()=>widget.cart.removeAt(i));
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Text("Total: Rs ${total()}"),

          ElevatedButton(
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (_)=>CheckoutScreen(total: total()))
              );
            },
            child: const Text("Checkout"),
          )
        ],
      ),
    );
  }
}

// ================= CHECKOUT =================
class CheckoutScreen extends StatelessWidget {
  final double total;
  const CheckoutScreen({super.key, required this.total});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            TextField(decoration: const InputDecoration(labelText: "Name")),
            TextField(decoration: const InputDecoration(labelText: "Phone")),
            TextField(decoration: const InputDecoration(labelText: "Address")),

            const SizedBox(height: 20),

            Text("Total: Rs $total"),

            ElevatedButton(
              onPressed: (){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Order Placed")),
                );
              },
              child: const Text("Place Order"),
            )
          ],
        ),
      ),
    );
  }
}

// ================= OTHER =================
class ReelsScreen extends StatelessWidget {
  const ReelsScreen({super.key});
  @override
  Widget build(BuildContext context)=>const Center(child: Text("Reels Coming Soon"));
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});
  @override
  Widget build(BuildContext context)=>const Center(child: Text("Wallet Coming Soon"));
}

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});
  @override
  Widget build(BuildContext context)=>const Center(child: Text("Login Coming Soon"));
}