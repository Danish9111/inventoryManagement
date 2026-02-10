import 'package:dream_pos/screens/sales/data/sample_sales_data.dart';
import 'package:dream_pos/screens/sales/models/sale_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class SalesNotifier extends StateNotifier<List<Sale>> {
  SalesNotifier() : super(SampleSalesData.getSampleSales());

  void addSale(Sale sale) {
    state = [...state, sale];
  }
}

final salesProvider = StateNotifierProvider<SalesNotifier, List<Sale>>((ref) {
  return SalesNotifier();
});
