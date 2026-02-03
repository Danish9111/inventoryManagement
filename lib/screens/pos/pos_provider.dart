import 'package:dream_pos/screens/products/providers/product_provider.dart';
import 'package:dream_pos/screens/products/model/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// -----------------------------------------------------------------------------
// MODEL: POS UI STATE
// -----------------------------------------------------------------------------
class PosState {
  final String selectedCategory;
  final bool showFeaturedOnly;
  final String searchQuery;
  final bool isHardwareScannerActive;

  PosState({
    this.selectedCategory = 'All',
    this.showFeaturedOnly = false,
    this.searchQuery = '',
    this.isHardwareScannerActive = false,
  });

  PosState copyWith({
    String? selectedCategory,
    bool? showFeaturedOnly,
    String? searchQuery,
    bool? isHardwareScannerActive,
  }) {
    return PosState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      showFeaturedOnly: showFeaturedOnly ?? this.showFeaturedOnly,
      searchQuery: searchQuery ?? this.searchQuery,
      isHardwareScannerActive:
          isHardwareScannerActive ?? this.isHardwareScannerActive,
    );
  }
}

// -----------------------------------------------------------------------------
// NOTIFIER: POS LOGIC
// -----------------------------------------------------------------------------
class PosNotifier extends Notifier<PosState> {
  @override
  PosState build() {
    return PosState();
  }

  // --- FILTERS ---

  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category, showFeaturedOnly: false);
  }

  void toggleFeatured(bool value) {
    state = state.copyWith(showFeaturedOnly: value);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

final posProvider = NotifierProvider<PosNotifier, PosState>(PosNotifier.new);

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final posState = ref.watch(posProvider);
  final products = ref.watch(productProvider);
  return products.where((product) {
    // Category filter
    if (posState.selectedCategory != 'All' &&
        product.category != posState.selectedCategory) {
      return false;
    }
    // Featured filter
    if (posState.showFeaturedOnly && !product.isFeatured) {
      return false;
    }
    // Search filter
    if (posState.searchQuery.isNotEmpty) {
      final query = posState.searchQuery.toLowerCase();
      return product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          (product.barcode?.contains(query) ?? false);
    }
    return true;
  }).toList();
});
