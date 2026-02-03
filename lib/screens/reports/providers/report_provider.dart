import 'package:dream_pos/screens/reports/models/report_models.dart';

import 'package:dream_pos/screens/reports/models/reportsState.dart';
import 'package:dream_pos/screens/sales/models/sale_model.dart';
import 'package:dream_pos/screens/sales/providers/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsNotifier extends Notifier<ReportsState> {
  @override
  ReportsState build() {
    final sales = ref.watch(salesProvider);

    // 1. Calculate KPI Stats
    double totalRevenue = 0;
    int totalOrders = sales.length;
    double totalProfit = 0; // Assuming 0 for now as we don't have cost price

    for (var sale in sales) {
      if (sale.status == SaleStatus.completed) {
        totalRevenue += sale.total;
      }
    }

    double avgOrderValue = totalOrders > 0 ? totalRevenue / totalOrders : 0;

    final stats = [
      Stat(
        label: 'Total Revenue',
        value: '\$${totalRevenue.toStringAsFixed(2)}',
        change: '+0%', // Dynamic change requires historical comparison
        isPositive: true,
      ),
      Stat(
        label: 'Total Orders',
        value: totalOrders.toString(),
        change: '+0%',
        isPositive: true,
      ),
      Stat(
        label: 'Avg. Order',
        value: '\$${avgOrderValue.toStringAsFixed(2)}',
        change: '+0%',
        isPositive: true,
      ),
      Stat(
        label: 'Net Benefit',
        value: '\$${totalProfit.toStringAsFixed(2)}',
        change: '+0%',
        isPositive: true,
      ),
    ];

    // 2. Weekly Sales Aggregation
    // Initialize map with last 7 days including today
    final now = DateTime.now();
    final Map<int, double> weeklyMap = {};
    // Create entries for last 7 days initialized to 0
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      // Use weekday as key (1=Mon, 7=Sun)
      // Note: This simple approach merges same weekdays if range > 1 week.
      // For strictly "last 7 days", we'd filter meaningful sales first.
      weeklyMap[date.weekday] = 0;
    }

    for (var sale in sales) {
      if (sale.status == SaleStatus.completed) {
        // Check if sale is within last 7 days
        final difference = now.difference(sale.timestamp).inDays;
        if (difference <= 7 && difference >= 0) {
          final weekday = sale.timestamp.weekday;
          weeklyMap[weekday] = (weeklyMap[weekday] ?? 0) + sale.total;
        }
      }
    }

    final List<String> weekDays = [
      '',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    final weeklySales = weeklyMap.entries.map((e) {
      return SalesDataPoint(label: weekDays[e.key], value: e.value);
    }).toList();

    // Sort by day order to make chart look correct (starting from 6 days ago)
    weeklySales.sort((a, b) {
      // This is a bit tricky since we map back to string.
      // Ideally we keep date info. For now let's just show what we have.
      // Better approach: iterate the last 7 days loop again to build the list in order.
      return 0;
    });

    // Re-doing weekly list correctly to ensure order:
    final List<SalesDataPoint> sortedWeeklySales = [];
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayName = weekDays[date.weekday];
      sortedWeeklySales.add(
        SalesDataPoint(label: dayName, value: weeklyMap[date.weekday] ?? 0),
      );
    }

    // 3. Payment Breakdown
    final Map<String, double> paymentMap = {};
    for (var sale in sales) {
      if (sale.status == SaleStatus.completed) {
        final method = sale.paymentMethod;
        paymentMap[method] = (paymentMap[method] ?? 0) + sale.total;
      }
    }

    final List<Color> pieColors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
    ];
    int colorIdx = 0;

    final paymentBackground = paymentMap.entries.map((e) {
      final percentage = totalRevenue > 0
          ? (e.value / totalRevenue) * 100
          : 0.0;
      return PaymentBreakdown(
        method: e.key,
        amount: e.value,
        percentage: percentage,
        color: pieColors[colorIdx++ % pieColors.length],
      );
    }).toList();

    // 4. Top Products
    final Map<String, ProductSalesData> productMap = {};
    for (var sale in sales) {
      if (sale.status == SaleStatus.completed) {
        for (var item in sale.items) {
          if (productMap.containsKey(item.productId)) {
            final existing = productMap[item.productId]!;
            productMap[item.productId] = ProductSalesData(
              productName: existing.productName,
              category: existing.category,
              quantitySold: existing.quantitySold + item.quantity,
              revenue: existing.revenue + item.totalPrice,
              profit: 0, // Need cost price
              trend: 'stable',
            );
          } else {
            productMap[item.productId] = ProductSalesData(
              productName: item.productName,
              category: 'General', // Placeholder, likely need product lookup
              quantitySold: item.quantity,
              revenue: item.totalPrice,
              profit: 0,
              trend: 'stable',
            );
          }
        }
      }
    }

    final topProducts = productMap.values.toList();
    topProducts.sort(
      (a, b) => b.revenue.compareTo(a.revenue),
    ); // Sort by revenue

    return ReportsState(
      stats: stats,
      weeklySales: sortedWeeklySales,
      paymentBackground: paymentBackground,
      topProducts: topProducts.take(5).toList(), // Top 5
      productReport: topProducts, // All for full report
    );
  }
}

final reportsProvider = NotifierProvider<ReportsNotifier, ReportsState>(
  ReportsNotifier.new,
);
