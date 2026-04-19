import 'package:flutter/material.dart';

class AdsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ads Manager"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            Icon(
              Icons.campaign,
              size: 80,
              color: Colors.blue,
            ),

            SizedBox(height: 20),

            Text(
              "Promote Your Business",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Apni ads chala kar sales barhayein",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 30),

            ListTile(
              leading: Icon(Icons.trending_up),
              title: Text("Boost Listing"),
            ),

            ListTile(
              leading: Icon(Icons.visibility),
              title: Text("Increase Views"),
            ),

            ListTile(
              leading: Icon(Icons.star),
              title: Text("Featured Ads"),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Go Back"),
            ),
          ],
        ),
      ),
    );
  }
}