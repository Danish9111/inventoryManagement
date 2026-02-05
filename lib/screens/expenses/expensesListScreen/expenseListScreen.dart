import 'package:dream_pos/screens/expenses/add_expense_screen.dart';
import 'package:dream_pos/screens/expenses/model/expense.dart';
import 'package:dream_pos/widgets/top_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/appColors.dart';
import 'expenseListFilters.dart';
import 'expenseListHeader.dart';
import 'expenseTableHeader.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  String searchQuery = '';
  String? selectedCategory;
  String? selectedStatus;

  late final List<String> categories;
  late final List<String> status;

  @override
  void initState() {
    super.initState();

    categories = Expense.expensesList.map((p) => p.category).toSet().toList();

    status = Expense.expensesList.map((p) => p.status).toSet().toList();
  }

  List<Expense> get filteredExpenses {
    return Expense.expensesList.where((expense) {
      final matchesSearch =
          searchQuery.isEmpty ||
          expense.name.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesCategory =
          selectedCategory == null || expense.category == selectedCategory;

      final matchesStatus =
          selectedStatus == null || expense.status == selectedStatus;

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(onRefresh: () => setState(() {})),
            const SizedBox(height: 16),
            Filters(
              categories: categories,
              brands: status,
              selectedCategory: selectedCategory,
              selectedStatus: selectedStatus,
              onSearch: (value) {
                setState(() => searchQuery = value);
              },
              onCategoryChanged: (value) {
                setState(() => selectedCategory = value);
              },
              onStatusChanged: (value) {
                setState(() => selectedStatus = value);
              },
            ),
            const SizedBox(height: 12),
            TableHeader(),
            Expanded(
              child: ListView.builder(
                itemCount: filteredExpenses.length,
                itemBuilder: (_, index) {
                  final expense = filteredExpenses[index];

                  return expenseTableRow(
                    expense: expense,

                    /// 🗑 DELETE
                    onDelete: () {
                      setState(() {
                        Expense.expensesList.removeWhere(
                          (p) => p.id == expense.id,
                        );
                      });
                    },

                    /// ✏️ EDIT
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddExpenseScreen(
                            expense: expense, // pass existing expense
                          ),
                        ),
                      ).then((_) {
                        setState(() {}); // refresh after edit
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class expenseListItem {
  final String sku;
  final String name;
  final String category;
  final String brand;
  final double price;
  final String unit;
  final int qty;
  final String createdBy;
  final String imageUrl;

  expenseListItem({
    required this.sku,
    required this.name,
    required this.category,
    required this.brand,
    required this.price,
    required this.unit,
    required this.qty,
    required this.createdBy,
    required this.imageUrl,
  });
}

class expenseTableRow extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const expenseTableRow({
    super.key,
    required this.expense,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE6E9EF))),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(expense.id)),
          _vDivider(),
          Expanded(flex: 3, child: Text(expense.name)),
          _vDivider(),
          Expanded(flex: 2, child: Text(expense.category)),
          _vDivider(),

          Expanded(flex: 2, child: Text('\$${expense.amount}')),
          _vDivider(),

          Expanded(flex: 2, child: Text(expense.status)),
          _vDivider(),

          Expanded(
            flex: 2,
            child: Text(DateFormat('dd MMM yyyy').format(expense.date)),
          ),
          _vDivider(),

          SizedBox(
            width: 120,
            child: Row(
              children: [
                squareIcon(
                  icon: Icons.edit,
                  onTap: onEdit,
                  color: AppColors.primaryOrange,
                ),
                const SizedBox(width: 8),
                squareIcon(
                  icon: Icons.delete,
                  onTap: onDelete,
                  color: AppColors.primaryOrange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vDivider() {
    return Container(
      height: 24, // adjust for row height
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.grey.shade300,
    );
  }
}
