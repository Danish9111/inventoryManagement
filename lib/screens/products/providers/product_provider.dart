import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/auth_service.dart';
import '../services/product_service.dart';
import '../model/product.dart';

/// Product Service provider (singleton)
final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

/// Auth Service provider (singleton)
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Products state - AsyncNotifier for modern Riverpod pattern
class ProductNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    // Fetch products when provider is first read
    return _fetchProducts();
  }

  /// Fetch products from API
  Future<List<Product>> _fetchProducts({
    String? category,
    String? search,
    bool? featured,
  }) async {
    try {
      final service = ref.read(productServiceProvider);
      final products = await service.getProducts(
        category: category,
        search: search,
        featured: featured,
      );
      return products;
    } catch (e) {
      rethrow;
    }
  }

  /// Get auth token or throw
  Future<String> _requireAuth() async {
    final authService = ref.read(authServiceProvider);
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('Please login as admin to perform this action');
    }
    return token;
  }

  /// Refresh products from API
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchProducts());
  }

  /// Filter products by category
  Future<void> filterByCategory(String category) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _fetchProducts(category: category == 'All' ? null : category),
    );
  }

  /// Search products
  Future<void> search(String query) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchProducts(search: query));
  }

  /// Get product by barcode
  Future<Product?> getByBarcode(String barcode) async {
    final service = ref.read(productServiceProvider);
    return await service.getProductByBarcode(barcode);
  }

  // ============ API METHODS (with auth) ============

  /// Create product via API
  Future<Product> createProduct(Product product) async {
    final token = await _requireAuth();
    final service = ref.read(productServiceProvider);
    final created = await service.createProduct(product, token);

    // Update local state immediately
    final currentProducts = state.hasValue ? state.value! : <Product>[];
    state = AsyncData([...currentProducts, created]);

    return created;
  }

  /// Update product via API
  Future<Product> updateProduct(Product product) async {
    final token = await _requireAuth();
    final service = ref.read(productServiceProvider);
    final updated = await service.updateProduct(product.id, product, token);

    // Update local state immediately
    final currentProducts = state.hasValue ? state.value! : <Product>[];
    state = AsyncData(
      currentProducts.map((p) => p.id == updated.id ? updated : p).toList(),
    );

    return updated;
  }

  /// Delete product via API
  Future<void> deleteProduct(String id, String token) async {
    final service = ref.read(productServiceProvider);
    final previous = state.value ?? [];
    try {
      service.deleteProduct(id, token);
      final success = await service.deleteProduct(id, token);
      if (!success) {
        state = AsyncData(previous);
      }
    } catch (e) {
      state = AsyncData(previous);
    }
    state = await AsyncValue.guard(() => _fetchProducts());
  }

  // ============ LOCAL-ONLY METHODS ============

  /// Remove product locally (without API - for optimistic updates)
  void removeProductLocally(String id) {
    state.whenData((products) {
      state = AsyncData(products.where((p) => p.id != id).toList());
    });
  }
}

/// Main product provider - AsyncNotifierProvider
final productProvider = AsyncNotifierProvider<ProductNotifier, List<Product>>(
  ProductNotifier.new,
);

/// Categories provider - fetches from API
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final service = ref.read(productServiceProvider);
  return await service.getCategories();
});

/// Filters the loaded products client-side for quick filtering.
///
/// Uses a Notifier with ref.listen() to properly detect state changes from
/// productProvider, including the AsyncLoading transition during refresh.
final filteredProductsProvider =
    NotifierProvider<FilteredProductsNotifier, AsyncValue<List<Product>>>(
      FilteredProductsNotifier.new,
    );

class FilteredProductsNotifier extends Notifier<AsyncValue<List<Product>>> {
  @override
  AsyncValue<List<Product>> build() {
    // Listen to productProvider changes
    ref.listen(productProvider, (previous, next) {
      _updateFilteredProducts();
    });

    // Listen to filter changes
    ref.listen(posFilterProvider, (previous, next) {
      _updateFilteredProducts();
    });

    // Initial computation
    return _computeFiltered();
  }

  void _updateFilteredProducts() {
    state = _computeFiltered();
  }

  AsyncValue<List<Product>> _computeFiltered() {
    final productsAsync = ref.read(productProvider);
    final posState = ref.read(posFilterProvider);

    // Check isLoading first to properly handle refresh state
    if (productsAsync.isLoading) {
      return const AsyncLoading();
    }

    if (productsAsync.hasError) {
      return AsyncError(productsAsync.error!, productsAsync.stackTrace!);
    }

    if (productsAsync.hasValue) {
      final filtered = productsAsync.value!.where((product) {
        // Category filter
        if (posState.category != 'All' &&
            product.category != posState.category) {
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
      return AsyncData(filtered);
    }

    return const AsyncLoading();
  }
}

/// POS filter state (for client-side filtering)
class PosFilterState {
  final String category;
  final bool showFeaturedOnly;
  final String searchQuery;

  const PosFilterState({
    this.category = 'All',
    this.showFeaturedOnly = false,
    this.searchQuery = '',
  });

  PosFilterState copyWith({
    String? category,
    bool? showFeaturedOnly,
    String? searchQuery,
  }) {
    return PosFilterState(
      category: category ?? this.category,
      showFeaturedOnly: showFeaturedOnly ?? this.showFeaturedOnly,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class PosFilterNotifier extends Notifier<PosFilterState> {
  @override
  PosFilterState build() => const PosFilterState();

  void setCategory(String category) {
    state = state.copyWith(category: category, showFeaturedOnly: false);
  }

  void toggleFeatured(bool value) {
    state = state.copyWith(showFeaturedOnly: value);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void reset() {
    state = const PosFilterState();
  }
}

final posFilterProvider = NotifierProvider<PosFilterNotifier, PosFilterState>(
  PosFilterNotifier.new,
);
