// Re-export from product_provider for backwards compatibility
// All POS filtering logic is now consolidated in product_provider.dart
export 'package:dream_pos/screens/products/providers/product_provider.dart'
    show
        posFilterProvider,
        PosFilterNotifier,
        PosFilterState,
        filteredProductsProvider,
        productProvider,
        categoriesProvider;
