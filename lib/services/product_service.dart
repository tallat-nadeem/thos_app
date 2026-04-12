import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  static Future<List<Product>> fetchProducts(int page,
      {int? categoryId}) async {
    
    // 🔥 Direct API
    String baseUrl =
        'https://tallatherbs.com/wp-json/wc/store/products?page=$page';

    if (categoryId != null) {
      baseUrl += '&category=$categoryId';
    }

    try {
      // ✅ FIRST TRY (Direct API)
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        print("✅ Direct API Success");
        return _parseProducts(response.body);
      } else {
        throw Exception("Direct API failed");
      }
    } catch (e) {
      print("⚠️ Direct failed, using proxy...");

      // 🔁 FALLBACK (Proxy for Web)
      String proxyUrl = 'https://corsproxy.io/?$baseUrl';

      final response = await http.get(Uri.parse(proxyUrl));

      if (response.statusCode == 200) {
        print("✅ Proxy API Success");
        return _parseProducts(response.body);
      } else {
        throw Exception('Failed to load products');
      }
    }
  }

  // 🔥 Common parser
  static List<Product> _parseProducts(String body) {
    List data = json.decode(body);

    return data.map((item) {
      return Product(
        id: item['id'],
        name: item['name'],
        price: (double.parse(item['prices']['price']) / 100).toString(),
        image: item['images'].isNotEmpty
            ? item['images'][0]['src']
            : '',
      );
    }).toList();
  }
}