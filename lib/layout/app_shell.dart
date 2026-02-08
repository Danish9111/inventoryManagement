import 'package:dream_pos/screens/barcode/barcode_screen.dart';
import 'package:dream_pos/screens/customers/customers_screen.dart';
import 'package:dream_pos/screens/dashboard/dashboard_screen.dart';
import 'package:dream_pos/screens/expenses/expensesListScreen/expenseListScreen.dart';
import 'package:dream_pos/screens/pos/pos_screen.dart';
import 'package:dream_pos/screens/products/productListScreen.dart';
import 'package:dream_pos/screens/reports/reports_screen.dart';
import 'package:dream_pos/screens/sales/sales_screen.dart';
import 'package:dream_pos/screens/setting/settings_screen.dart';
import 'package:dream_pos/widgets/side_bar.dart';
import 'package:dream_pos/widgets/top_app_bar.dart';
import 'package:flutter/material.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;

  void _navigateTo(int index) {
    setState(() => selectedIndex = index);
  }

  List<Widget> get _screens => [
    DashboardScreen(onNavigate: _navigateTo),
    const PosScreen(),
    const ProductListScreen(),
    const SalesScreen(),
    const CustomersScreen(),
    const ReportsScreen(),
    const BarcodeScreen(),
    const ExpenseListScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: TopAppBar(onNavigate: (index, _) => _navigateTo(index)),
      ),
      body: Row(
        children: [
          /// 👈 SIDEBAR (FIXED)
          SingleChildScrollView(
            child: SideBar(
              selectedIndex: selectedIndex,
              onItemSelected: _navigateTo,
            ),
          ),

          /// 👉 MAIN CONTENT
          Expanded(
            child: IndexedStack(index: selectedIndex, children: _screens),
          ),
        ],
      ),
    );
  }
}
