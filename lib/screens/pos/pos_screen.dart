import 'package:dream_pos/screens/pos/cart_provider.dart';
import 'package:dream_pos/screens/pos/models/receipt_model.dart';
import 'package:dream_pos/screens/pos/pos_responsive_helper.dart';
import 'package:dream_pos/screens/pos/widgets/discount_dialog.dart';
import 'package:dream_pos/screens/pos/widgets/payment_dialog.dart';
import 'package:dream_pos/screens/pos/widgets/pos_cart_panel.dart';
import 'package:dream_pos/screens/pos/widgets/pos_products_panel.dart';
import 'package:dream_pos/screens/pos/widgets/receipt_dialog.dart';
import 'package:dream_pos/screens/products/providers/product_provider.dart';
import 'package:dream_pos/screens/sales/models/sale_model.dart';
import 'package:dream_pos/screens/sales/providers/sales_provider.dart';
import 'package:dream_pos/constants/appColors.dart';
import 'package:dream_pos/widgets/hardware_scanner_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> {
  // Use a fixed tax rate or get from settings provider
  static const double _taxRate = 5.0;

  Future<void> _handleBarcodeScanned(String barcode) async {
    if (barcode.isEmpty) return;

    final cartNotifier = ref.read(cartProvider.notifier);
    final productNotifier = ref.read(productProvider.notifier);

    // Try to find product by barcode via API
    try {
      final product = await productNotifier.getByBarcode(barcode);

      if (product != null && product.id.isNotEmpty) {
        cartNotifier.addToCart(product);
        if (mounted) {
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
        }
      } else {
        if (mounted) {
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Error: ${e.toString()}')),
              ],
            ),
            backgroundColor: AppColors.expensesRed,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showDiscountDialog(PosResponsiveHelper r) {
    final cartState = ref.read(cartProvider);
    showDialog(
      context: context,
      builder: (context) => DiscountDialog(
        subtotal: cartState.subtotal,
        currentDiscount: cartState.discount,
        onApply: (discount) {
          ref.read(cartProvider.notifier).applyDiscount(discount);
        },
        responsive: r,
      ),
    );
  }

  void _showPaymentDialog(PosResponsiveHelper r) {
    final cartState = ref.read(cartProvider);
    final subTotal = cartState.subtotal;
    final discountAmount = cartState.discountAmount;
    final tax = subTotal * _taxRate / 100;
    final total = subTotal + tax - discountAmount;

    showDialog(
      context: context,
      builder: (context) => PaymentDialog(
        total: total,
        subtotal: subTotal,
        tax: tax,
        discount: discountAmount,
        itemCount: cartState.totalItems,
        onPaymentComplete: (paymentMethod, {double? amountReceived}) {
          _completeSale(
            paymentMethod,
            amountReceived: amountReceived,
            taxRate: _taxRate,
          );
        },
        responsive: r,
      ),
    );
  }

  void _completeSale(
    String paymentMethod, {
    double? amountReceived,
    required double taxRate,
  }) {
    final cartState = ref.read(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final salesNotifier = ref.read(salesProvider.notifier);

    final subTotal = cartState.subtotal;
    final discountAmount = cartState.discountAmount;
    final total = subTotal + (subTotal * taxRate / 100) - discountAmount;

    // Create Receipt
    final receipt = Receipt.fromCart(
      cartItems: List.from(cartState.cartItems),
      customerName: cartState.selectedCustomer,
      subtotal: subTotal,
      taxRate: taxRate,
      discountAmount: discountAmount,
      paymentMethod: paymentMethod,
      amountReceived: amountReceived,
    );

    // Create Sale
    final sale = Sale(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderId:
          '#ORD${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      timestamp: DateTime.now(),
      customerName: cartState.selectedCustomer,
      items: cartState.cartItems
          .map(
            (item) => SaleItem(
              productId: item.product.id,
              productName: item.product.name,
              quantity: item.quantity,
              unitPrice: item.product.price,
              totalPrice: item.totalPrice,
            ),
          )
          .toList(),
      subtotal: subTotal,
      tax: subTotal * taxRate / 100,
      discount: discountAmount,
      total: total,
      paymentMethod: paymentMethod,
    );

    // Save & Clear
    salesNotifier.addSale(sale);
    cartNotifier.clearCart();

    // Show Receipt
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ReceiptDialog(
          receipt: receipt,
          responsive: PosResponsiveHelper(MediaQuery.of(context).size.width),
          onDone: () {},
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final r = PosResponsiveHelper(screenWidth);

        return HardwareScannerListener(
          onBarcodeScanned: (barcode) {
            _handleBarcodeScanned(barcode);
          },
          child: Container(
            color: AppColors.backgroundGrey,
            child: Row(
              children: [
                // 📦 LEFT PANEL - Products
                Expanded(
                  flex: 62,
                  child: RepaintBoundary(
                    child: PosProductsPanel(
                      responsive: r,
                      onBarcodeScanned: _handleBarcodeScanned,
                    ),
                  ),
                ),

                // 🧾 RIGHT PANEL - Cart/Order
                Expanded(
                  flex: 38,
                  child: RepaintBoundary(
                    child: PosCartPanel(
                      responsive: r,
                      onDiscountTap: () => _showDiscountDialog(r),
                      onPaymentTap: () => _showPaymentDialog(r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
