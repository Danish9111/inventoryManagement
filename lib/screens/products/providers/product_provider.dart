import 'package:dream_pos/screens/products/data/productsData.dart';
import 'package:dream_pos/screens/products/model/product.dart';
import 'package:flutter_riverpod/legacy.dart';

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super(productsList);

  void addProduct(Product product) {
    state = [...state, product];
  }

  void updateProduct(Product product) {
    state = state.map((p) => p.id == product.id ? product : p).toList();
  }

  void deleteProduct(String id) {
    state = state.where((p) => p.id != id).toList();
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, List<Product>>(
  (ref) => ProductNotifier(),
);
