import 'package:dream_pos/providers/auth_provider.dart';
import 'package:dream_pos/screens/customers/services/customer_service.dart';
import 'package:dream_pos/utils/api_result.dart';
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

  void deleteCustomer(String id) async {
    final authAsync = ref.read(authProvider);
    final token = authAsync.value?.token;
    if (token == null) {
      throw Exception("Not authorized as token is null");
    }
    final service = CustomerService();
    final result = await service.deleteCustomer(id, token);
    if (result is Success) {
      final currentCustomers = state.value ?? [];
      state = AsyncData(currentCustomers.where((c) => c.id != id).toList());
    } else if (result is Failure) {
      throw Exception(result.message);
    }
  }

  Future<ApiResult<Customer>> updateCustomer(
    String id,
    Customer customer,
  ) async {
    final token = ref.read(authProvider).value?.token;
    if (token != null) {
      final result = await CustomerService().updateCustomer(
        id,
        token,
        customer,
      );
      if (result is Success<Customer>) {
        final currentCustomers = state.value ?? [];
        state = AsyncData(
          currentCustomers.map((c) => c.id == id ? result.data : c).toList(),
        );
      }
      return result;
    }
    return Failure(message: "Not authorized as token is null");
  }
}

final customerProvider =
    AsyncNotifierProvider<CustomerNotifier, List<Customer>>(() {
      return CustomerNotifier();
    });
