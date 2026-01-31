/// Sale Status Enum
enum SaleStatus { completed, refunded, voided }

/// Individual item in a sale
class SaleItem {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  SaleItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });
}

/// Sale Model for history tracking
class Sale {
  final String id;
  final String orderId;
  final DateTime timestamp;
  final String customerName;
  final List<SaleItem> items;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final String paymentMethod;
  final SaleStatus status;

  Sale({
    required this.id,
    required this.orderId,
    required this.timestamp,
    required this.customerName,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    this.status = SaleStatus.completed,
  });

  /// Get total items count
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  /// Get status display text
  String get statusText {
    switch (status) {
      case SaleStatus.completed:
        return 'Completed';
      case SaleStatus.refunded:
        return 'Refunded';
      case SaleStatus.voided:
        return 'Voided';
    }
  }

  /// Get payment method icon
  String get paymentIcon {
    switch (paymentMethod.toLowerCase()) {
      case 'cash':
        return '💵';
      case 'card':
        return '💳';
      case 'mobile':
        return '📱';
      default:
        return '💰';
    }
  }
}
