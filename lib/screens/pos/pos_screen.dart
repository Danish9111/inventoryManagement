import 'package:dream_pos/screens/pos/models/cart_item_model.dart';
import 'package:dream_pos/screens/pos/models/order_model.dart';
import 'package:dream_pos/screens/pos/models/receipt_model.dart';
import 'package:dream_pos/screens/pos/pos_responsive_helper.dart';
import 'package:dream_pos/screens/pos/widgets/cart_item_tile.dart';
import 'package:dream_pos/screens/pos/widgets/category_filter.dart';
import 'package:dream_pos/screens/pos/widgets/discount_dialog.dart';
import 'package:dream_pos/screens/pos/widgets/payment_dialog.dart';
import 'package:dream_pos/screens/pos/widgets/products_grid.dart';
import 'package:dream_pos/screens/pos/widgets/receipt_dialog.dart';
import 'package:dream_pos/screens/products/data/productsData.dart';
import 'package:dream_pos/widgets/appColors.dart';
import 'package:dream_pos/widgets/hardware_scanner_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../products/model/product.dart';

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> {
  // Products & Filtering
  final List<Product> _products = productsList;
  String _selectedCategory = 'All';
  bool _showFeaturedOnly = false;
  final TextEditingController _barcodeController = TextEditingController();

  // Use ValueNotifier for search to isolate rebuilds
  final ValueNotifier<String> _searchNotifier = ValueNotifier('');

  // Cart
  final List<CartItem> _cartItems = [];
  Discount? _discount;
  final double _taxRate = 5.0; // 5% tax
  final TextEditingController _searchController = TextEditingController();

  // Filtered Products - now accepts searchQuery as parameter
  List<Product> _getFilteredProducts(String searchQuery) {
    return _products.where((product) {
      // Category filter
      if (_selectedCategory != 'All' && product.category != _selectedCategory) {
        return false;
      }
      // Featured filter
      if (_showFeaturedOnly && !product.isFeatured) {
        return false;
      }
      // Search filter
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        return product.name.toLowerCase().contains(query) ||
            product.category.toLowerCase().contains(query) ||
            (product.barcode?.contains(query) ?? false);
      }
      return true;
    }).toList();
  }

  // Cart Calculations
  double get _subtotal =>
      _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  double get _discountAmount => _discount?.calculateDiscount(_subtotal) ?? 0;

  int get _totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  // Get cart quantities as a Map for ProductsGrid widget
  Map<String, int> get _cartQuantities {
    return {for (var item in _cartItems) item.product.id: item.quantity};
  }

  // Add product to cart
  void _addToCart(Product product) {
    setState(() {
      final existingIndex = _cartItems.indexWhere(
        (i) => i.product.id == product.id,
      );
      if (existingIndex >= 0) {
        _cartItems[existingIndex].quantity++;
      } else {
        _cartItems.add(CartItem(product: product));
      }
    });
  }

  // Increment cart item
  void _incrementItem(String productId) {
    setState(() {
      final index = _cartItems.indexWhere((i) => i.product.id == productId);
      if (index >= 0) {
        _cartItems[index].quantity++;
      }
    });
  }

  // Decrement cart item
  void _decrementItem(String productId) {
    setState(() {
      final index = _cartItems.indexWhere((i) => i.product.id == productId);
      if (index >= 0) {
        if (_cartItems[index].quantity > 1) {
          _cartItems[index].quantity--;
        } else {
          _cartItems.removeAt(index);
        }
      }
    });
  }

  // Remove cart item
  void _removeItem(String productId) {
    setState(() {
      _cartItems.removeWhere((i) => i.product.id == productId);
    });
  }

  // Clear cart
  void _clearCart() {
    setState(() {
      _cartItems.clear();
      _discount = null;
    });
  }

  // Show discount dialog
  void _showDiscountDialog(PosResponsiveHelper r) {
    showDialog(
      context: context,
      builder: (context) => DiscountDialog(
        subtotal: _subtotal,
        currentDiscount: _discount,
        onApply: (discount) {
          setState(() => _discount = discount);
        },
        responsive: r,
      ),
    );
  }

  // Show payment dialog
  void _showPaymentDialog(PosResponsiveHelper r) {
    _cachedResponsive = r; // Cache for receipt dialog
    showDialog(
      context: context,
      builder: (context) => PaymentDialog(
        total: _subtotal + (_subtotal * _taxRate / 100) - _discountAmount,
        subtotal: _subtotal,
        tax: _subtotal * _taxRate / 100,
        discount: _discountAmount,
        itemCount: _totalItems,
        onPaymentComplete: (paymentMethod, {double? amountReceived}) {
          _completeSale(paymentMethod, amountReceived: amountReceived);
        },
        responsive: r,
      ),
    );
  }

  // Cache responsive helper for receipt dialog
  PosResponsiveHelper? _cachedResponsive;

  // Pending receipt to show after payment dialog closes
  Receipt? _pendingReceipt;

  // Complete sale - Show receipt dialog
  void _completeSale(String paymentMethod, {double? amountReceived}) {
    // Create receipt from current cart BEFORE clearing
    _pendingReceipt = Receipt.fromCart(
      cartItems: List.from(_cartItems),
      customerName: _selectedCustomer,
      subtotal: _subtotal,
      taxRate: _taxRate,
      discountAmount: _discountAmount,
      paymentMethod: paymentMethod,
      amountReceived: amountReceived,
    );

    // Clear cart first
    _clearCart();

    // Show receipt dialog after a short delay to let payment dialog close
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showReceiptDialog();
    });
  }

  void _showReceiptDialog() {
    if (_pendingReceipt == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ReceiptDialog(
        receipt: _pendingReceipt!,
        responsive:
            _cachedResponsive ??
            PosResponsiveHelper(MediaQuery.of(context).size.width),
        onDone: () {
          _pendingReceipt = null;
        },
      ),
    );
  }

  // Handle barcode scanned (from hardware scanner or manual input)
  void _handleBarcodeScanned(String barcode) {
    // Find product by barcode
    final product = _products.firstWhere(
      (p) => p.barcode == barcode,
      orElse: () => Product(
        id: '',
        name: '',
        slug: '',
        sku: '',
        category: '',
        subCategory: '',
        brand: '',
        unit: '',
        sellingType: '',
        price: 0,
        quantity: 0,
        quantityAlert: 0,
        images: [],
      ),
    );

    if (product.id.isNotEmpty) {
      // Product found - add to cart
      _addToCart(product);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('Added: ${product.name}'),
            ],
          ),
          backgroundColor: AppColors.purchaseGreen,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      // Product not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Text('Product not found: $barcode'),
            ],
          ),
          backgroundColor: AppColors.expensesRed,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Barcode scan button - now shows a dialog hinting at hardware scanner
  void _scanBarcode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            constraints: BoxConstraints(maxHeight: 300), // limit height
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
                  controller: _barcodeController,
                  decoration: InputDecoration(
                    labelText: 'Barcode',
                    border: OutlineInputBorder(),
                    hintText: "Enter the barcode",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        final barcode = _barcodeController.text.trim();
                        // final barcode = _barcodeController.text.trim();

                        if (barcode.isEmpty) return;

                        final product = _products.firstWhere(
                          (p) => p.barcode == barcode,
                          orElse: () {
                            return Product(
                              id: '',
                              name: '',
                              slug: '',
                              sku: '',
                              category: '',
                              subCategory: '',
                              brand: '',
                              unit: '',
                              sellingType: '',
                              price: 0,
                              quantity: 0,
                              quantityAlert: 0,
                              images: [],
                            );
                          },
                        );
                        if (product.id.isNotEmpty) _addToCart(product);
                        _barcodeController.clear();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your USB/Bluetooth barcode scanner is ready. Just scan a product barcode and it will be added to the cart automatically.',
                  style: TextStyle(color: AppColors.textGrey, height: 1.5),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final r = PosResponsiveHelper(screenWidth);

        return HardwareScannerListener(
          onBarcodeScanned: _handleBarcodeScanned,
          child: Container(
            color: AppColors.backgroundGrey,
            child: Row(
              children: [
                // 📦 LEFT PANEL - Products
                Expanded(
                  flex: 62,
                  child: RepaintBoundary(child: _buildProductsPanel(r)),
                ),

                // 🧾 RIGHT PANEL - Cart/Order
                Expanded(
                  flex: 38,
                  child: RepaintBoundary(child: _buildCartPanel(r)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 📦 LEFT PANEL - Products Grid
  Widget _buildProductsPanel(PosResponsiveHelper r) {
    return Container(
      padding: EdgeInsets.all(r.panelPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Welcome & Search
          _buildProductsHeader(r),

          SizedBox(height: r.sectionSpacing),

          // Category Filters
          CategoryFilter(
            categories: Product.categories,
            selectedCategory: _selectedCategory,
            showFeaturedOnly: _showFeaturedOnly,
            onCategorySelected: (cat) {
              setState(() {
                _selectedCategory = cat;
                _showFeaturedOnly = false;
              });
            },
            onFeaturedToggle: (val) {
              setState(() => _showFeaturedOnly = val);
            },
            responsive: r,
          ),

          SizedBox(height: r.sectionSpacing),

          // Products Grid - Wrapped with ValueListenableBuilder for efficient search
          Expanded(
            child: ValueListenableBuilder<String>(
              valueListenable: _searchNotifier,
              builder: (context, searchQuery, _) {
                // Only this section rebuilds when search changes!
                return _buildProductsGrid(r, searchQuery);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Products Header with Search
  Widget _buildProductsHeader(PosResponsiveHelper r) {
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
              controller: _searchController,
              onChanged: (value) => _searchNotifier.value = value,
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
                  onPressed: _scanBarcode,
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

  Widget _buildProductsGrid(PosResponsiveHelper r, String searchQuery) {
    return ProductsGrid(
      products: _getFilteredProducts(searchQuery),
      cartQuantities: _cartQuantities,
      onAddToCart: _addToCart,
      onDecrement: _decrementItem,
      onRemove: _removeItem,
      responsive: r,
    );
  }

  // Customer Management
  String _selectedCustomer = 'Walk in Customer';
  final List<Map<String, dynamic>> _customers = [
    {'name': 'Walk in Customer', 'bonus': 0, 'loyalty': 0},
    {'name': 'James Anderson', 'bonus': 148, 'loyalty': 20},
    {'name': 'Sarah Johnson', 'bonus': 75, 'loyalty': 15},
    {'name': 'Mike Williams', 'bonus': 200, 'loyalty': 50},
  ];

  Map<String, dynamic> get _currentCustomer =>
      _customers.firstWhere((c) => c['name'] == _selectedCustomer);

  /// 🧾 RIGHT PANEL - Cart/Order with CustomScrollView
  Widget _buildCartPanel(PosResponsiveHelper r) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: Column(
        children: [
          // 🔒 FIXED HEADER - Order List
          _buildCartHeaderCompact(r),

          // 📜 SCROLLABLE CONTENT - Everything between header and footer
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Customer Management Section
                SliverToBoxAdapter(child: _buildCustomerSection(r)),

                // Order Details Header
                SliverToBoxAdapter(child: _buildOrderDetailsHeader(r)),

                // Cart Items List
                _cartItems.isEmpty
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: _buildEmptyCart(r),
                      )
                    : SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: r.scale(10, 14),
                          vertical: r.scale(6, 10),
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final item = _cartItems[index];
                            return CartItemTile(
                              cartItem: item,
                              onIncrement: () =>
                                  _incrementItem(item.product.id),
                              onDecrement: () =>
                                  _decrementItem(item.product.id),
                              onRemove: () => _removeItem(item.product.id),
                              responsive: r,
                            );
                          }, childCount: _cartItems.length),
                        ),
                      ),
              ],
            ),
          ),

          // 🔒 FIXED FOOTER - Order Summary & Pay Button
          _cartItems.isNotEmpty ? _buildOrderSummaryCompact(r) : SizedBox(),
        ],
      ),
    );
  }

  /// Empty Cart State
  Widget _buildEmptyCart(PosResponsiveHelper r) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: r.scale(48, 64),
            color: AppColors.textGrey.withOpacity(0.3),
          ),
          SizedBox(height: r.scale(12, 16)),
          Text(
            'No items in cart',
            style: TextStyle(
              fontSize: r.scale(14, 16),
              fontWeight: FontWeight.w500,
              color: AppColors.textGrey,
            ),
          ),
          SizedBox(height: r.scale(4, 8)),
          Text(
            'Tap on products to add them',
            style: TextStyle(
              fontSize: r.scale(11, 13),
              color: AppColors.textGrey.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// Compact Cart Header
  Widget _buildCartHeaderCompact(PosResponsiveHelper r) {
    final orderId =
        '#ORD${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.scale(12, 18),
        vertical: r.scale(10, 14),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Order List',
            style: TextStyle(
              fontSize: r.scale(15, 18),
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          Row(
            children: [
              // Order ID Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: r.scale(8, 10),
                  vertical: r.scale(3, 5),
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  orderId,
                  style: TextStyle(
                    fontSize: r.scale(9, 11),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: r.scale(6, 8)),
              // Delete All Button
              InkWell(
                onTap: _cartItems.isNotEmpty ? _clearCart : null,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: EdgeInsets.all(r.scale(5, 7)),
                  decoration: BoxDecoration(
                    color: _cartItems.isNotEmpty
                        ? AppColors.expensesRed
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    size: r.scale(14, 18),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Customer Management Section
  Widget _buildCustomerSection(PosResponsiveHelper r) {
    final customer = _currentCustomer;
    final hasBonus = customer['bonus'] > 0 || customer['loyalty'] > 0;

    return Container(
      padding: EdgeInsets.all(r.scale(10, 14)),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Information',
            style: TextStyle(
              fontSize: r.scale(12, 14),
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: r.scale(8, 12)),

          // Customer Dropdown Row
          Row(
            children: [
              // Dropdown
              Expanded(
                child: Container(
                  height: r.scale(36, 42),
                  padding: EdgeInsets.symmetric(horizontal: r.scale(10, 14)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(r.scale(8, 10)),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: AppColors.white,
                      value: _selectedCustomer,
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: r.scale(18, 22),
                        color: AppColors.textGrey,
                      ),
                      style: TextStyle(
                        fontSize: r.scale(11, 13),
                        color: AppColors.textDark,
                      ),
                      items: _customers.map((c) {
                        return DropdownMenuItem<String>(
                          value: c['name'] as String,
                          child: Text(c['name'] as String),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedCustomer = value);
                        }
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(width: r.scale(8, 10)),

              // Add Customer Button
              _buildIconButton(
                icon: Icons.person_add_outlined,
                color: AppColors.primaryBlue,
                onTap: () {
                  // TODO: Add new customer
                },
                r: r,
              ),
              SizedBox(width: r.scale(6, 8)),

              // Refresh Button
              _buildIconButton(
                icon: Icons.swap_horiz_rounded,
                color: AppColors.primaryBlue,
                onTap: () {
                  setState(() => _selectedCustomer = 'Walk in Customer');
                },
                r: r,
              ),
            ],
          ),

          // Customer Bonus/Loyalty Info
          if (hasBonus) ...[
            SizedBox(height: r.scale(8, 12)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: r.scale(10, 14),
                vertical: r.scale(8, 12),
              ),
              decoration: BoxDecoration(
                color: AppColors.customersTealLight,
                borderRadius: BorderRadius.circular(r.scale(8, 10)),
                border: Border.all(
                  color: AppColors.customersTeal.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer['name'] as String,
                          style: TextStyle(
                            fontSize: r.scale(12, 14),
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        SizedBox(height: r.scale(4, 6)),
                        Row(
                          children: [
                            _buildBadge(
                              'Bonus: ${customer['bonus']}',
                              AppColors.primaryBlue,
                              r,
                            ),
                            SizedBox(width: r.scale(6, 10)),
                            _buildBadge(
                              'Loyalty: \$${customer['loyalty']}',
                              AppColors.purchaseGreen,
                              r,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: r.scale(10, 14),
                      vertical: r.scale(6, 8),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.purchaseGreen,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: r.scale(10, 12),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required PosResponsiveHelper r,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(r.scale(8, 10)),
      child: Container(
        width: r.scale(36, 42),
        height: r.scale(36, 42),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(r.scale(8, 10)),
        ),
        child: Icon(icon, color: Colors.white, size: r.scale(18, 22)),
      ),
    );
  }

  Widget _buildBadge(String text, Color color, PosResponsiveHelper r) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.scale(6, 8),
        vertical: r.scale(2, 4),
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: r.scale(9, 11),
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Order Details Header
  Widget _buildOrderDetailsHeader(PosResponsiveHelper r) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.scale(12, 18),
        vertical: r.scale(8, 12),
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Order Details',
                    style: TextStyle(
                      fontSize: r.scale(12, 14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(width: r.scale(8, 10)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: r.scale(6, 10),
                      vertical: r.scale(2, 4),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Items : $_totalItems',
                      style: TextStyle(
                        fontSize: r.scale(9, 11),
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: _cartItems.isNotEmpty ? _clearCart : null,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.scale(8, 12),
                    vertical: r.scale(4, 6),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.expensesRedLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Clear all',
                    style: TextStyle(
                      fontSize: r.scale(9, 11),
                      fontWeight: FontWeight.w600,
                      color: AppColors.expensesRed,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: r.scale(8, 10)),
          // Column Headers
          Row(
            children: [
              SizedBox(width: r.scale(28, 36)), // Delete button space
              Expanded(
                flex: 3,
                child: Text(
                  'Item',
                  style: TextStyle(
                    fontSize: r.scale(10, 12),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              SizedBox(
                width: r.scale(80, 100),
                child: Text(
                  'QTY',
                  style: TextStyle(
                    fontSize: r.scale(10, 12),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: r.scale(50, 70),
                child: Text(
                  'Cost',
                  style: TextStyle(
                    fontSize: r.scale(10, 12),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textGrey,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Compact Order Summary & Pay Button
  Widget _buildOrderSummaryCompact(PosResponsiveHelper r) {
    final tax = _subtotal * (_taxRate / 100);
    final total = _subtotal + tax - _discountAmount;

    return Container(
      padding: EdgeInsets.all(r.scale(10, 14)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Summary Rows - Compact
          _buildSummaryRowCompact('Subtotal', _subtotal, r),
          SizedBox(height: r.scale(4, 6)),
          _buildSummaryRowCompact(
            'Tax (${_taxRate.toStringAsFixed(0)}%)',
            tax,
            r,
          ),
          SizedBox(height: r.scale(4, 6)),

          // Discount Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Discount',
                    style: TextStyle(
                      fontSize: r.scale(11, 13),
                      color: AppColors.textGrey,
                    ),
                  ),
                  SizedBox(width: r.scale(6, 8)),
                  InkWell(
                    onTap: _cartItems.isNotEmpty
                        ? () => _showDiscountDialog(r)
                        : null,
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.scale(6, 10),
                        vertical: r.scale(2, 4),
                      ),
                      decoration: BoxDecoration(
                        color: _cartItems.isNotEmpty
                            ? AppColors.purchaseGreen
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Apply',
                        style: TextStyle(
                          fontSize: r.scale(9, 11),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '-\$${_discountAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: r.scale(11, 13),
                  fontWeight: FontWeight.w600,
                  color: AppColors.purchaseGreen,
                ),
              ),
            ],
          ),

          Divider(color: AppColors.cardBorder, height: r.scale(12, 18)),

          // Total Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: r.scale(14, 17),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: r.scale(14, 17),
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),

          SizedBox(height: r.scale(10, 14)),

          // Compact Pay Button
          SizedBox(
            width: double.infinity,
            height: r.scale(38, 46),
            child: ElevatedButton(
              onPressed: _cartItems.isNotEmpty
                  ? () => _showPaymentDialog(r)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _cartItems.isNotEmpty
                    ? AppColors.purchaseGreen
                    : Colors.grey.shade300,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(r.scale(8, 10)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payment_rounded, size: r.scale(16, 20)),
                  SizedBox(width: r.scale(6, 10)),
                  Text(
                    'Pay Now',
                    style: TextStyle(
                      fontSize: r.scale(13, 15),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRowCompact(
    String label,
    double value,
    PosResponsiveHelper r,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: r.scale(11, 13),
            color: AppColors.textGrey,
          ),
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: r.scale(11, 13),
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
