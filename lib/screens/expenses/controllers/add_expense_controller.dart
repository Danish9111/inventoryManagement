import 'package:flutter/material.dart';

import '../model/expense.dart';

class AddExpenseController {
  // Controllers
  final TextEditingController expenseNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Dropdown / selectors
  String? category;
  String status = 'Paid'; // default
  DateTime date = DateTime.now();

  /// Validate form data
  bool isValid() {
    return expenseNameController.text.isNotEmpty &&
        amountController.text.isNotEmpty &&
        category != null;
  }

  /// Create Expense object
  Expense createExpense(String id) {
    return Expense(
      id: id,
      name: expenseNameController.text.trim(),
      category: category!,
      amount: double.tryParse(amountController.text) ?? 0,
      description: descriptionController.text.isEmpty
          ? null
          : descriptionController.text.trim(),
      date: date,
      status: status,
    );
  }

  /// Reset form
  void reset() {
    expenseNameController.clear();
    amountController.clear();
    descriptionController.clear();

    category = null;
    status = 'Paid';
    date = DateTime.now();
  }

  /// Dispose controllers
  void dispose() {
    expenseNameController.dispose();
    amountController.dispose();
    descriptionController.dispose();
  }
}
