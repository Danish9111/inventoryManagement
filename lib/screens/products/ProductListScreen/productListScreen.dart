import 'package:dream_pos/screens/products/ProductListScreen/productListFilters.dart';
import 'package:dream_pos/screens/products/ProductListScreen/productListHeader.dart';
import 'package:dream_pos/screens/products/ProductListScreen/productTableHeader.dart';

import 'package:dream_pos/screens/products/model/product.dart';
import 'package:dream_pos/screens/products/providers/product_provider.dart';
import 'package:dream_pos/widgets/top_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/appColors.dart';
import '../add_product_screen.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  String searchQuery = '';
  String? selectedCategory;
  String? selectedBrand;

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);

    final categories = products.map((p) => p.category).toSet().toList();
    final brands = products.map((p) => p.brand).toSet().toList();

    List<Product> filteredProducts = products.where((product) {
      final matchesSearch =
          searchQuery.isEmpty ||
          product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          product.sku.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesCategory =
          selectedCategory == null || product.category == selectedCategory;

      final matchesBrand =
          selectedBrand == null || product.brand == selectedBrand;

      return matchesSearch && matchesCategory && matchesBrand;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(onRefresh: () => setState(() {})),
            const SizedBox(height: 16),
            Filters(
              categories: categories,
              brands: brands,
              selectedCategory: selectedCategory,
              selectedBrand: selectedBrand,
              onSearch: (value) {
                setState(() => searchQuery = value);
              },
              onCategoryChanged: (value) {
                setState(() => selectedCategory = value);
              },
              onBrandChanged: (value) {
                setState(() => selectedBrand = value);
              },
            ),
            const SizedBox(height: 12),
            TableHeader(),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (_, index) {
                  final product = filteredProducts[index];

                  return ProductTableRow(
                    product: product,

                    /// 🗑 DELETE
                    onDelete: () {
                      ref
                          .read(productProvider.notifier)
                          .deleteProduct(product.id);
                    },

                    /// ✏️ EDIT
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddProductScreen(
                            product: product, // pass existing product
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductListItem {
  final String sku;
  final String name;
  final String category;
  final String brand;
  final double price;
  final String unit;
  final int qty;
  final String createdBy;
  final String imageUrl;

  ProductListItem({
    required this.sku,
    required this.name,
    required this.category,
    required this.brand,
    required this.price,
    required this.unit,
    required this.qty,
    required this.createdBy,
    required this.imageUrl,
  });
}

class ProductTableRow extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ProductTableRow({
    super.key,
    required this.product,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE6E9EF))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: product.images.isNotEmpty
                      ? AssetImage(product.images.first)
                      : null,
                  child: product.images.isEmpty
                      ? Image.asset('assets/images/blogo.png')
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(product.name)),
              ],
            ),
          ),
          _vDivider(),
          Expanded(flex: 2, child: Text(product.category)),
          _vDivider(),
          Expanded(flex: 2, child: Text(product.brand)),
          _vDivider(),

          Expanded(flex: 2, child: Text('\$${product.price}')),
          _vDivider(),

          Expanded(flex: 2, child: Text(product.unit)),
          _vDivider(),

          Expanded(flex: 2, child: Text(product.quantity.toString())),
          _vDivider(),

          SizedBox(
            width: 120,
            child: Row(
              children: [
                squareIcon(
                  icon: Icons.edit,
                  onTap: onEdit,
                  color: AppColors.primaryOrange,
                ),
                const SizedBox(width: 8),
                squareIcon(
                  icon: Icons.delete,
                  onTap: onDelete,
                  color: AppColors.primaryOrange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vDivider() {
    return Container(
      height: 24, // adjust for row height
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.grey.shade300,
    );
  }
}
