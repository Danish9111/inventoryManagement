import '../models/sale_model.dart';

/// Sample sales data for UI prototyping
class SampleSalesData {
  static List<Sale> getSampleSales() {
    final now = DateTime.now();

    return [
      // Today's sales
      Sale(
        id: 'S001',
        orderId: 'ORD-2026-001',
        timestamp: now.subtract(const Duration(minutes: 15)),
        customerName: 'John Smith',
        items: [
          SaleItem(
            productId: 'P001',
            productName: 'Wireless Headphones',
            quantity: 1,
            unitPrice: 89.99,
            totalPrice: 89.99,
          ),
          SaleItem(
            productId: 'P002',
            productName: 'Phone Case',
            quantity: 2,
            unitPrice: 19.99,
            totalPrice: 39.98,
          ),
        ],
        subtotal: 129.97,
        tax: 10.40,
        discount: 10.00,
        total: 130.37,
        paymentMethod: 'Card',
        status: SaleStatus.completed,
      ),
      Sale(
        id: 'S002',
        orderId: 'ORD-2026-002',
        timestamp: now.subtract(const Duration(hours: 1)),
        customerName: 'Sarah Johnson',
        items: [
          SaleItem(
            productId: 'P003',
            productName: 'USB-C Cable',
            quantity: 3,
            unitPrice: 12.99,
            totalPrice: 38.97,
          ),
        ],
        subtotal: 38.97,
        tax: 3.12,
        discount: 0,
        total: 42.09,
        paymentMethod: 'Cash',
        status: SaleStatus.completed,
      ),
      Sale(
        id: 'S003',
        orderId: 'ORD-2026-003',
        timestamp: now.subtract(const Duration(hours: 2)),
        customerName: 'Mike Williams',
        items: [
          SaleItem(
            productId: 'P004',
            productName: 'Bluetooth Speaker',
            quantity: 1,
            unitPrice: 149.99,
            totalPrice: 149.99,
          ),
          SaleItem(
            productId: 'P005',
            productName: 'AUX Cable',
            quantity: 1,
            unitPrice: 8.99,
            totalPrice: 8.99,
          ),
          SaleItem(
            productId: 'P006',
            productName: 'Screen Protector',
            quantity: 2,
            unitPrice: 14.99,
            totalPrice: 29.98,
          ),
        ],
        subtotal: 188.96,
        tax: 15.12,
        discount: 20.00,
        total: 184.08,
        paymentMethod: 'Card',
        status: SaleStatus.completed,
      ),
      Sale(
        id: 'S004',
        orderId: 'ORD-2026-004',
        timestamp: now.subtract(const Duration(hours: 4)),
        customerName: 'Emily Brown',
        items: [
          SaleItem(
            productId: 'P007',
            productName: 'Laptop Stand',
            quantity: 1,
            unitPrice: 59.99,
            totalPrice: 59.99,
          ),
        ],
        subtotal: 59.99,
        tax: 4.80,
        discount: 0,
        total: 64.79,
        paymentMethod: 'Mobile',
        status: SaleStatus.refunded,
      ),

      // Yesterday's sales
      Sale(
        id: 'S005',
        orderId: 'ORD-2026-005',
        timestamp: now.subtract(const Duration(days: 1, hours: 2)),
        customerName: 'David Lee',
        items: [
          SaleItem(
            productId: 'P008',
            productName: 'Mechanical Keyboard',
            quantity: 1,
            unitPrice: 129.99,
            totalPrice: 129.99,
          ),
          SaleItem(
            productId: 'P009',
            productName: 'Mouse Pad XL',
            quantity: 1,
            unitPrice: 24.99,
            totalPrice: 24.99,
          ),
        ],
        subtotal: 154.98,
        tax: 12.40,
        discount: 15.00,
        total: 152.38,
        paymentMethod: 'Card',
        status: SaleStatus.completed,
      ),
      Sale(
        id: 'S006',
        orderId: 'ORD-2026-006',
        timestamp: now.subtract(const Duration(days: 1, hours: 5)),
        customerName: 'Lisa Garcia',
        items: [
          SaleItem(
            productId: 'P010',
            productName: 'Webcam HD',
            quantity: 1,
            unitPrice: 79.99,
            totalPrice: 79.99,
          ),
        ],
        subtotal: 79.99,
        tax: 6.40,
        discount: 0,
        total: 86.39,
        paymentMethod: 'Cash',
        status: SaleStatus.completed,
      ),

      // This week sales
      Sale(
        id: 'S007',
        orderId: 'ORD-2026-007',
        timestamp: now.subtract(const Duration(days: 2)),
        customerName: 'James Wilson',
        items: [
          SaleItem(
            productId: 'P011',
            productName: 'USB Hub',
            quantity: 2,
            unitPrice: 29.99,
            totalPrice: 59.98,
          ),
          SaleItem(
            productId: 'P012',
            productName: 'HDMI Cable 6ft',
            quantity: 3,
            unitPrice: 15.99,
            totalPrice: 47.97,
          ),
        ],
        subtotal: 107.95,
        tax: 8.64,
        discount: 5.00,
        total: 111.59,
        paymentMethod: 'Card',
        status: SaleStatus.completed,
      ),
      Sale(
        id: 'S008',
        orderId: 'ORD-2026-008',
        timestamp: now.subtract(const Duration(days: 3)),
        customerName: 'Walk-in Customer',
        items: [
          SaleItem(
            productId: 'P013',
            productName: 'Earbuds Pro',
            quantity: 1,
            unitPrice: 199.99,
            totalPrice: 199.99,
          ),
        ],
        subtotal: 199.99,
        tax: 16.00,
        discount: 0,
        total: 215.99,
        paymentMethod: 'Mobile',
        status: SaleStatus.voided,
      ),
      Sale(
        id: 'S009',
        orderId: 'ORD-2026-009',
        timestamp: now.subtract(const Duration(days: 4)),
        customerName: 'Amanda Taylor',
        items: [
          SaleItem(
            productId: 'P014',
            productName: 'Tablet Stand',
            quantity: 1,
            unitPrice: 34.99,
            totalPrice: 34.99,
          ),
          SaleItem(
            productId: 'P015',
            productName: 'Stylus Pen',
            quantity: 2,
            unitPrice: 24.99,
            totalPrice: 49.98,
          ),
        ],
        subtotal: 84.97,
        tax: 6.80,
        discount: 0,
        total: 91.77,
        paymentMethod: 'Card',
        status: SaleStatus.completed,
      ),
      Sale(
        id: 'S010',
        orderId: 'ORD-2026-010',
        timestamp: now.subtract(const Duration(days: 5)),
        customerName: 'Robert Martinez',
        items: [
          SaleItem(
            productId: 'P016',
            productName: 'Monitor Arm',
            quantity: 1,
            unitPrice: 89.99,
            totalPrice: 89.99,
          ),
        ],
        subtotal: 89.99,
        tax: 7.20,
        discount: 10.00,
        total: 87.19,
        paymentMethod: 'Cash',
        status: SaleStatus.completed,
      ),
    ];
  }

  /// Get today's sales summary
  static Map<String, dynamic> getTodaySummary(List<Sale> sales) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todaySales = sales.where((sale) {
      final saleDate = DateTime(
        sale.timestamp.year,
        sale.timestamp.month,
        sale.timestamp.day,
      );
      return saleDate == today && sale.status == SaleStatus.completed;
    }).toList();

    final totalRevenue = todaySales.fold<double>(
      0,
      (sum, sale) => sum + sale.total,
    );
    final totalItems = todaySales.fold<int>(
      0,
      (sum, sale) => sum + sale.totalItems,
    );

    return {
      'count': todaySales.length,
      'revenue': totalRevenue,
      'items': totalItems,
      'average': todaySales.isEmpty ? 0.0 : totalRevenue / todaySales.length,
    };
  }
}
