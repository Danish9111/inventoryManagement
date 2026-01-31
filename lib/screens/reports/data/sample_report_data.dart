import 'package:dream_pos/widgets/appColors.dart';
import 'package:flutter/material.dart';
import '../models/report_models.dart';

/// Sample data for Reports prototype
class SampleReportData {
  // === REPORT TYPES ===
  static List<ReportType> get reportTypes => [
    const ReportType(
      id: 'sales_summary',
      title: 'Sales Summary',
      subtitle: 'Daily revenue & orders',
    ),
    const ReportType(
      id: 'products',
      title: 'Product Sales',
      subtitle: 'Best & worst sellers',
    ),
    const ReportType(
      id: 'inventory',
      title: 'Inventory',
      subtitle: 'Stock levels & alerts',
    ),
    const ReportType(
      id: 'payments',
      title: 'Payments',
      subtitle: 'Payment methods breakdown',
    ),
    const ReportType(
      id: 'profit',
      title: 'Profit & Loss',
      subtitle: 'Financial performance',
    ),
    const ReportType(
      id: 'hourly',
      title: 'Hourly Analysis',
      subtitle: 'Peak hours & patterns',
    ),
  ];

  // === KPI STATS ===
  static List<StatCard> get todayStats => [
    const StatCard(
      label: "Today's Revenue",
      value: '\$4,285.00',
      change: '+12.5%',
      isPositive: true,
    ),
    const StatCard(
      label: 'Total Orders',
      value: '47',
      change: '+8 orders',
      isPositive: true,
    ),
    const StatCard(
      label: 'Avg. Order Value',
      value: '\$91.17',
      change: '+3.2%',
      isPositive: true,
    ),
    const StatCard(
      label: 'Items Sold',
      value: '156',
      change: '+24 items',
      isPositive: true,
    ),
  ];

  // === WEEKLY SALES DATA ===
  static List<SalesDataPoint> get weeklySales => [
    const SalesDataPoint(label: 'Mon', value: 3200, previousValue: 2800),
    const SalesDataPoint(label: 'Tue', value: 2800, previousValue: 3100),
    const SalesDataPoint(label: 'Wed', value: 3600, previousValue: 3400),
    const SalesDataPoint(label: 'Thu', value: 4100, previousValue: 3800),
    const SalesDataPoint(label: 'Fri', value: 5200, previousValue: 4600),
    const SalesDataPoint(label: 'Sat', value: 6100, previousValue: 5800),
    const SalesDataPoint(label: 'Sun', value: 4285, previousValue: 4200),
  ];

  // === TOP PRODUCTS ===
  static List<ProductSalesData> get topProducts => [
    const ProductSalesData(
      productName: 'iPhone 14 64GB',
      category: 'Mobiles',
      quantitySold: 12,
      revenue: 189600,
      profit: 28440,
      trend: 'up',
    ),
    const ProductSalesData(
      productName: 'MacBook Pro',
      category: 'Computers',
      quantitySold: 8,
      revenue: 8000,
      profit: 1600,
      trend: 'up',
    ),
    const ProductSalesData(
      productName: 'Samsung Galaxy S24',
      category: 'Mobiles',
      quantitySold: 15,
      revenue: 187500,
      profit: 28125,
      trend: 'stable',
    ),
    const ProductSalesData(
      productName: 'Sony WH-1000XM5',
      category: 'Audio',
      quantitySold: 22,
      revenue: 9900,
      profit: 2475,
      trend: 'up',
    ),
    const ProductSalesData(
      productName: 'Nike Air Max',
      category: 'Shoes',
      quantitySold: 18,
      revenue: 7164,
      profit: 1791,
      trend: 'down',
    ),
  ];

  static List<PaymentBreakdown> get paymentBreakdown => [
    const PaymentBreakdown(
      method: 'Cash',
      amount: 1714.00,
      percentage: 40.0,
      color: Color(0xFF10B981),
    ),
    const PaymentBreakdown(
      method: 'Card',
      amount: 1928.25,
      percentage: 45.0,
      color: AppColors.primaryBlue,
    ),
    const PaymentBreakdown(
      method: 'Digital',
      amount: 642.75,
      percentage: 15.0,
      color: Colors.cyanAccent,
    ),
  ];

  // === HOURLY SALES (for pattern analysis) ===
  static List<SalesDataPoint> get hourlySales => [
    const SalesDataPoint(label: '9AM', value: 120),
    const SalesDataPoint(label: '10AM', value: 280),
    const SalesDataPoint(label: '11AM', value: 450),
    const SalesDataPoint(label: '12PM', value: 620),
    const SalesDataPoint(label: '1PM', value: 580),
    const SalesDataPoint(label: '2PM', value: 390),
    const SalesDataPoint(label: '3PM', value: 340),
    const SalesDataPoint(label: '4PM', value: 420),
    const SalesDataPoint(label: '5PM', value: 510),
    const SalesDataPoint(label: '6PM', value: 380),
    const SalesDataPoint(label: '7PM', value: 195),
  ];
}
