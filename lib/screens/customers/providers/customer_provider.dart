import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/customer_model.dart';

class CustomerNotifier extends Notifier<List<Customer>> {
  @override
  List<Customer> build() {
    return _sampleCustomers;
  }

  static final List<Customer> _sampleCustomers = [
    Customer(
      id: 'CUST-001',
      name: 'John Smith',
      email: 'john.smith@example.com',
      phone: '+1 (555) 123-4567',
      address: '123 Maple Ave, Springfield',
      totalSpent: 1250.50,
      loyaltyPoints: 125,
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
    ),
    Customer(
      id: 'CUST-002',
      name: 'Sarah Johnson',
      email: 'sarah.j@example.com',
      phone: '+1 (555) 987-6543',
      address: '456 Oak St, Metropolis',
      totalSpent: 2840.00,
      loyaltyPoints: 284,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
    Customer(
      id: 'CUST-003',
      name: 'Michael Brown',
      email: 'm.brown@example.com',
      phone: '+1 (555) 456-7890',
      address: '789 Pine Rd, Gotham City',
      totalSpent: 450.25,
      loyaltyPoints: 45,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
    Customer(
      id: 'CUST-004',
      name: 'Emily Davis',
      email: 'emily.d@example.com',
      phone: '+1 (555) 234-5678',
      address: '321 Elm St, Central City',
      totalSpent: 3120.75,
      loyaltyPoints: 312,
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
    ),
    Customer(
      id: 'CUST-005',
      name: 'David Wilson',
      email: 'david.w@example.com',
      phone: '+1 (555) 876-5432',
      address: '654 Cedar Ln, Star City',
      totalSpent: 890.00,
      loyaltyPoints: 89,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  void addCustomer(Customer customer) {
    state = [...state, customer];
  }

  void updateCustomer(Customer updatedCustomer) {
    state = [
      for (final customer in state)
        if (customer.id == updatedCustomer.id) updatedCustomer else customer,
    ];
  }

  void deleteCustomer(String id) {
    state = state.where((customer) => customer.id != id).toList();
  }
}

final customerProvider = NotifierProvider<CustomerNotifier, List<Customer>>(() {
  return CustomerNotifier();
});
