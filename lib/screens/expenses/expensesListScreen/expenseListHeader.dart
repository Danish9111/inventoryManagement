import 'package:dream_pos/screens/expenses/add_expense_screen.dart';
import 'package:flutter/material.dart';

import '../../../widgets/customButtons.dart';

class Header extends StatelessWidget {
  final VoidCallback onRefresh;

  const Header({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Expenses List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Manage your Expenses',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        const Spacer(),
        const SizedBox(width: 8),
        CustomElevatedButton(
          text: 'Add Expense',
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => AddExpenseScreen()));
          },
          width: 135,
          height: 40,
          textSize: 14,
        ),
      ],
    );
  }
}
