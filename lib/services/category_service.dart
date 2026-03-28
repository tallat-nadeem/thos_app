import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class CategoryService {
  static Future<List<Category>> fetchCategories() async {
    final url =
        'https://corsproxy.io/?https://tallatherbs.com/wp-json/wc/store/products/categories';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);

      return data.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}