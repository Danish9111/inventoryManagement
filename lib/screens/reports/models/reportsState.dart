import 'package:dream_pos/screens/reports/models/report_models.dart';

class ReportsState {
  final List<Stat> stats;
  final List<SalesDataPoint> weeklySales;
  final List<PaymentBreakdown> paymentBackground;
  final List<ProductSalesData> productReport;
  final List<ProductSalesData> topProducts;

  ReportsState({
    required this.stats,
    required this.weeklySales,
    required this.paymentBackground,
    required this.productReport,
    required this.topProducts,
  });

  factory ReportsState.initial() => ReportsState(
    stats: [],
    weeklySales: [],
    paymentBackground: [],
    productReport: [],
    topProducts: [],
  );
}
