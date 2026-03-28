import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../services/product_service.dart';
import '../services/category_service.dart';
import '../widgets/product_image.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = [];
  List<Category> categories = [];

  int page = 1;
  bool isLoading = false;
  int? selectedCategoryId;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchCategories();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> fetchProducts({int? categoryId, bool reset = false}) async {
    if (isLoading) return;

    if (reset) {
      page = 1;
      products.clear();
    }

    setState(() {
      isLoading = true;
    });

    final newProducts =
        await ProductService.fetchProducts(page, categoryId: categoryId);

    setState(() {
      page++;
      products.addAll(newProducts);
      isLoading = false;
    });
  }

  Future<void> fetchCategories() async {
    final data = await CategoryService.fetchCategories();
    setState(() {
      categories = data;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoading) {
      fetchProducts(categoryId: selectedCategoryId);
    }
  }

  void onCategorySelected(int? id) {
    setState(() {
      selectedCategoryId = id;
    });
    fetchProducts(categoryId: id, reset: true);
  }

  void openProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: const [
            Text("THOS"),
            Text("by TALLAT HERBS", style: TextStyle(fontSize: 12)),
            Text("🌐 www.tallatherbs.com", style: TextStyle(fontSize: 10)),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: categories.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return categoryItem("All", null);
                      }

                      final cat = categories[index - 1];
                      return categoryItem(cat.name, cat.id);
                    },
                  ),
          ),

          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: products.length + 1,
              itemBuilder: (context, index) {
                if (index < products.length) {
                  final product = products[index];

                  return GestureDetector(
                    onTap: () => openProduct(product),
                    child: Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        leading: ProductImage(imageUrl: product.image),
                        title: Text(product.name),
                        subtitle: Text("Rs ${product.price}"),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: isLoading
                          ? CircularProgressIndicator()
                          : SizedBox(),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryItem(String name, int? id) {
    final isSelected = selectedCategoryId == id;

    return GestureDetector(
      onTap: () => onCategorySelected(id),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}