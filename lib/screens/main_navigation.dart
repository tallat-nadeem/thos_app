import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'products_screen.dart';
import 'cart_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {

  int selectedIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),                         // 0 👉 HOME
    ProductsScreen(),                     // 1 👉 PRODUCTS
    Center(child: Text("Reels Screen")),  // 2 👉 REELS (temporary)
    CartScreen(),                         // 3 👉 CART
    Center(child: Text("Profile Screen")) // 4 👉 PROFILE
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: "Products",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection),
            label: "Reels",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}