import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../services/product_service.dart';
import '../services/category_service.dart';
import '../widgets/product_image.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

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

    setState(() => isLoading = true);

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
    setState(() => categories = data);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoading) {
      fetchProducts(categoryId: selectedCategoryId);
    }
  }

  void onCategorySelected(int? id) {
    setState(() => selectedCategoryId = id);
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
    return Column(
      children: [
        // 🔹 Categories
        SizedBox(
          height: 60,
          child: categories.isEmpty
              ? const Center(child: CircularProgressIndicator())
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

        // 🔹 Products Grid
        Expanded(
          child: products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(10),
                  itemCount: products.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 🔥 2 boxes per row
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7, // 🔥 height control
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return GestureDetector(
                      onTap: () => openProduct(product),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              color: Colors.grey.withOpacity(0.2),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🖼️ Image
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: ProductImage(
                                  imageUrl: product.image,
                                ),
                              ),
                            ),

                            // 📦 Name
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),

                            // 💰 Price
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                "Rs ${product.price}",
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),

                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget categoryItem(String name, int? id) {
    final isSelected = selectedCategoryId == id;

    return GestureDetector(
      onTap: () => onCategorySelected(id),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12),
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