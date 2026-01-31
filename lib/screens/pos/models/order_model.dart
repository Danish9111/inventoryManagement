/// Discount Model
enum DiscountType { percentage, fixed }

class Discount {
  final DiscountType type;
  final double value;
  final String? code;

  Discount({required this.type, required this.value, this.code});

  double calculateDiscount(double subtotal) {
    if (type == DiscountType.percentage) {
      return subtotal * (value / 100);
    }
    return value;
  }

  String get displayText {
    if (type == DiscountType.percentage) {
      return '${value.toStringAsFixed(0)}%';
    }
    return '\$${value.toStringAsFixed(2)}';
  }
}

/// Order Model
class Order {
  final String orderId;
  final List<CartItemData> items;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final String paymentMethod;
  final DateTime createdAt;

  Order({
    required this.orderId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.createdAt,
  });
}

/// Simplified cart item data for order history
class CartItemData {
  final String productId;
  final String productName;
  final double price;
  final int quantity;

  CartItemData({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });
}
