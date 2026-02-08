import 'package:dream_pos/screens/products/widgets/productTableBody.dart';
import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  const TableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: const [
          Cell(flex: 1, text: 'ID'),
          Cell(flex: 3, text: 'Expense Name'),
          Cell(flex: 2, text: 'Category'),
          Cell(flex: 2, text: 'Amount'),
          Cell(flex: 2, text: 'Status'),
          Cell(flex: 2, text: 'Date'),
          // Cell(flex: 2, text: 'Created By'),
          Cell(width: 120, text: 'Actions'),
        ],
      ),
    );
  }
}
