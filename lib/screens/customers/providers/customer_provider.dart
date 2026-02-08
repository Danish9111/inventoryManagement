import 'package:dream_pos/providers/auth_provider.dart';
import 'package:dream_pos/screens/customers/services/customer_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/customer_model.dart';

class CustomerNotifier extends AsyncNotifier<List<Customer>> {
  @override
  Future<List<Customer>> build() async {
    final authAsync = ref.watch(authProvider);

    if (!authAsync.hasValue) {
      return [];
    }

    final token = authAsync.value?.token;
    if (token == null) {
      return [];
    }

    final service = CustomerService();
    return await service.getCustomers(token);
  }

  void deleteCustomer(String id) {}
}

final customerProvider =
    AsyncNotifierProvider<CustomerNotifier, List<Customer>>(() {
      return CustomerNotifier();
    });
