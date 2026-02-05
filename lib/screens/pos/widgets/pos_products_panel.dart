import 'package:dream_pos/screens/pos/cart_provider.dart';
import 'package:dream_pos/screens/pos/pos_provider.dart';
import 'package:dream_pos/screens/pos/pos_responsive_helper.dart';
import 'package:dream_pos/screens/pos/widgets/category_filter.dart';
import 'package:dream_pos/screens/pos/widgets/products_grid.dart';
import 'package:dream_pos/screens/products/model/product.dart';
import 'package:dream_pos/constants/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PosProductsPanel extends ConsumerWidget {
  final PosResponsiveHelper responsive;
  final Function(String) onBarcodeScanned;

  const PosProductsPanel({
    super.key,
    required this.responsive,
    required this.onBarcodeScanned,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posState = ref.watch(posProvider);
    final posNotifier = ref.read(posProvider.notifier);
    final cartNotifier = ref.read(cartProvider.notifier);

    // Efficiently watch cart items only for quantity updates if needed
    final cartState = ref.watch(cartProvider);

    Map<String, int> cartQuantities = {
      for (var item in cartState.cartItems) item.product.id: item.quantity,
    };

    final filteredProducts = ref.watch(filteredProductsProvider);

    return Container(
      padding: EdgeInsets.all(responsive.panelPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Welcome & Search
          _buildProductsHeader(ref, responsive, posState.searchQuery),

          SizedBox(height: responsive.sectionSpacing),

          // Category Filters
          CategoryFilter(
            categories: Product.categories,
            selectedCategory: posState.selectedCategory,
            showFeaturedOnly: posState.showFeaturedOnly,
            onCategorySelected: (cat) => posNotifier.setCategory(cat),
            onFeaturedToggle: (val) => posNotifier.toggleFeatured(val),
            responsive: responsive,
          ),

          SizedBox(height: responsive.sectionSpacing),

          // Products Grid
          Expanded(
            child: ProductsGrid(
              products: filteredProducts,
              cartQuantities: cartQuantities,
              onAddToCart: cartNotifier.addToCart,
              onDecrement: cartNotifier.decrement,
              onRemove: cartNotifier.remove,
              responsive: responsive,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsHeader(
    WidgetRef ref,
    PosResponsiveHelper r,
    String searchQuery,
  ) {
    final now = DateTime.now();
    final dateFormat = DateFormat('MMMM dd, yyyy');

    return Row(
      children: [
        // Welcome Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, User',
                style: TextStyle(
                  fontSize: r.headerTitleSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              SizedBox(height: r.scale(2, 4)),
              Text(
                dateFormat.format(now),
                style: TextStyle(
                  fontSize: r.headerSubtitleSize,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),

        // Search Bar
        Expanded(
          flex: 2,
          child: SizedBox(
            height: r.searchHeight,
            child: TextField(
              onChanged: (value) =>
                  ref.read(posProvider.notifier).setSearchQuery(value),
              decoration: InputDecoration(
                hintText: 'Search Product',
                hintStyle: TextStyle(
                  fontSize: r.scale(12, 14),
                  color: AppColors.textGrey,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: r.scale(18, 22),
                  color: AppColors.textGrey,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    _showScanDialog(ref.context);
                  },
                  icon: Icon(
                    Icons.qr_code_scanner_rounded,
                    size: r.scale(18, 22),
                    color: AppColors.primaryBlue,
                  ),
                  tooltip: 'Scan Barcode',
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: r.scale(12, 16),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(r.scale(10, 14)),
                  borderSide: BorderSide(color: AppColors.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(r.scale(10, 14)),
                  borderSide: BorderSide(color: AppColors.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(r.scale(10, 14)),
                  borderSide: BorderSide(
                    color: AppColors.primaryBlue,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showScanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _BarcodeScanDialog(onScanned: onBarcodeScanned),
    );
  }
}

class _BarcodeScanDialog extends StatefulWidget {
  final Function(String) onScanned;
  const _BarcodeScanDialog({required this.onScanned});

  @override
  State<_BarcodeScanDialog> createState() => _BarcodeScanDialogState();
}

class _BarcodeScanDialogState extends State<_BarcodeScanDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      title: Row(
        children: [
          Icon(Icons.qr_code_scanner, color: AppColors.primaryBlue),
          const SizedBox(width: 12),
          const Text('Barcode Scanner'),
        ],
      ),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.purchaseGreenLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.purchaseGreen),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Hardware scanner is active!\nSimply scan any barcode.',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Barcode',
                  border: const OutlineInputBorder(),
                  hintText: "Enter the barcode",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      final barcode = _controller.text.trim();
                      if (barcode.isNotEmpty) {
                        widget.onScanned(barcode);
                        _controller.clear();
                      }
                    },
                  ),
                ),
                onSubmitted: (val) {
                  if (val.trim().isNotEmpty) {
                    widget.onScanned(val.trim());
                    _controller.clear();
                  }
                },
                autofocus: true,
              ),
              const SizedBox(height: 16),
              Text(
                'Your USB/Bluetooth barcode scanner is ready. Just scan a product barcode.',
                style: TextStyle(color: AppColors.textGrey, height: 1.5),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
