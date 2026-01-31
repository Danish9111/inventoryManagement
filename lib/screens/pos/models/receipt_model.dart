import 'package:dream_pos/screens/pos/models/cart_item_model.dart';

/// Receipt model for completed sales
class Receipt {
  final String orderId;
  final DateTime timestamp;
  final String customerName;
  final List<ReceiptItem> items;
  final double subtotal;
  final double taxRate;
  final double tax;
  final double discountAmount;
  final double total;
  final String paymentMethod;
  final double? amountReceived;
  final double? change;

  // Store info (can be made configurable later)
  static const String storeName = 'DREAM POS';
  static const String storeAddress = '123 Business Street, City';
  static const String storePhone = '+1 234 567 890';
  static const String footerMessage = 'Thank you for shopping with us!';

  Receipt({
    required this.orderId,
    required this.timestamp,
    required this.customerName,
    required this.items,
    required this.subtotal,
    required this.taxRate,
    required this.tax,
    required this.discountAmount,
    required this.total,
    required this.paymentMethod,
    this.amountReceived,
    this.change,
  });

  /// Create receipt from cart items
  factory Receipt.fromCart({
    required List<CartItem> cartItems,
    required String customerName,
    required double subtotal,
    required double taxRate,
    required double discountAmount,
    required String paymentMethod,
    double? amountReceived,
  }) {
    final tax = subtotal * (taxRate / 100);
    final total = subtotal + tax - discountAmount;
    final change = amountReceived != null ? amountReceived - total : null;

    return Receipt(
      orderId:
          'ORD${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      timestamp: DateTime.now(),
      customerName: customerName,
      items: cartItems.map((item) => ReceiptItem.fromCartItem(item)).toList(),
      subtotal: subtotal,
      taxRate: taxRate,
      tax: tax,
      discountAmount: discountAmount,
      total: total,
      paymentMethod: paymentMethod,
      amountReceived: amountReceived,
      change: change != null && change > 0 ? change : null,
    );
  }
}

/// Individual item on receipt
class ReceiptItem {
  final String name;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  ReceiptItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory ReceiptItem.fromCartItem(CartItem cartItem) {
    return ReceiptItem(
      name: cartItem.product.name,
      quantity: cartItem.quantity,
      unitPrice: cartItem.product.price.toDouble(),
      totalPrice: cartItem.totalPrice.toDouble(),
    );
  }
}
