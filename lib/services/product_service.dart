import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {

  static Future<List<Product>> fetchProducts(int page, {int? categoryId}) async {

    String url =
        'https://tallatherbs.com/wp-json/wc/store/products?page=$page';

    if (categoryId != null) {
      url += '&category=$categoryId';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);

      return data.map((item) {

        return Product(
          id: item['id'],
          name: item['name'],
          price: (double.parse(item['prices']['price']) / 100).toString(),
          image: item['images'].isNotEmpty
              ? item['images'][0]['src']
              : '',
          description: item['description'] ?? "No description",
          categoryId: item['categories'].isNotEmpty
              ? item['categories'][0]['id']
              : 0,
        );

      }).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}