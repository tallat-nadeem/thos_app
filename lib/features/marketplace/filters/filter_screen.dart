import 'package:flutter/material.dart';

class FilterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filters"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            ListTile(
              leading: Icon(Icons.factory),
              title: Text("Factory"),
            ),

            ListTile(
              leading: Icon(Icons.store),
              title: Text("Wholesale"),
            ),

            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text("Retail"),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Apply Filters"),
            ),
          ],
        ),
      ),
    );
  }
}