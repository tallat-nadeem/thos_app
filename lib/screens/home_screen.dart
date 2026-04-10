import 'package:flutter/material.dart';
import 'package:thos_app/screens/home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('THOS'),
      ),
      body: Column(
        children: [
          const Expanded(
            child: Center(
              child: Text(
                'Welcome to THOS',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            color: Colors.grey.shade200,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Start Selling'),
            ),
          ),
        ],
      ),
    );
  }
}