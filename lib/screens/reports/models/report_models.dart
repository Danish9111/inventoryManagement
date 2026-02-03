import 'package:flutter/material.dart';

/// Report Type Card Model
class ReportType {
  final String id;
  final String title;
  final String subtitle;

  const ReportType({
    required this.id,
    required this.title,
    required this.subtitle,
  });
}

/// KPI Stat Card Model
class Stat {
  final String label;
  final String value;
  final String? change;
  final bool isPositive;

  const Stat({
    required this.label,
    required this.value,
    this.change,
    this.isPositive = true,
  });
}

/// Sales Data Point for Charts
class SalesDataPoint {
  final String label;
  final double value;
  final double? previousValue;

  const SalesDataPoint({
    required this.label,
    required this.value,
    this.previousValue,
  });
}

/// Product Sales for Table
class ProductSalesData {
  final String productName;
  final String category;
  final int quantitySold;
  final double revenue;
  final double profit;
  final String trend; // 'up', 'down', 'stable'

  const ProductSalesData({
    required this.productName,
    required this.category,
    required this.quantitySold,
    required this.revenue,
    required this.profit,
    required this.trend,
  });
}

/// Payment Method Breakdown
class PaymentBreakdown {
  final String method;
  final double amount;
  final double percentage;
  final Color color;

  const PaymentBreakdown({
    required this.method,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}

/// Date Filter Options
enum DateFilterOption {
  today,
  yesterday,
  thisWeek,
  lastWeek,
  thisMonth,
  lastMonth,
  custom,
}

extension DateFilterExtension on DateFilterOption {
  String get label {
    switch (this) {
      case DateFilterOption.today:
        return 'Today';
      case DateFilterOption.yesterday:
        return 'Yesterday';
      case DateFilterOption.thisWeek:
        return 'This Week';
      case DateFilterOption.lastWeek:
        return 'Last Week';
      case DateFilterOption.thisMonth:
        return 'This Month';
      case DateFilterOption.lastMonth:
        return 'Last Month';
      case DateFilterOption.custom:
        return 'Custom Range';
    }
  }
}
