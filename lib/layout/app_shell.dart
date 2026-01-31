import 'package:dream_pos/screens/barcode/barcode_screen.dart';
import 'package:dream_pos/screens/expenses/expensesListScreen/expenseListScreen.dart';
import 'package:dream_pos/screens/products/ProductListScreen/productListScreen.dart';
import 'package:dream_pos/screens/sales/sales_screen.dart';
import 'package:flutter/material.dart';

import '../screens/dashboard/dashboard_screen.dart';
import '../screens/pos/pos_screen.dart';
import '../screens/setting/settings_screen.dart';
import '../widgets/side_bar.dart';
import '../widgets/top_app_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void navigateTo(int index, Widget screen) {
    setState(() => selectedIndex = index);

    _navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: TopAppBar(onNavigate: navigateTo),
      ),

      body: Row(
        children: [
          /// 👈 SIDEBAR (FIXED)
          SingleChildScrollView(
            child: SideBar(
              selectedIndex: selectedIndex,
              onItemSelected: (index) {
                switch (index) {
                  case 0:
                    navigateTo(0, const DashboardScreen());
                    break;
                  case 1:
                    navigateTo(1, const PosScreen());
                    break;
                  case 2:
                    navigateTo(2, const ProductListScreen());
                    break;
                  case 3:
                    navigateTo(3, const SalesScreen());
                    break;
                  case 4:
                    navigateTo(4, const BarcodeScreen());
                    break;
                  case 5:
                    navigateTo(5, const ExpenseListScreen());
                    break;
                  case 6:
                    navigateTo(6, const SettingsScreen());
                    break;
                }
              },
            ),
          ),

          /// 👉 MAIN CONTENT (CHANGES ONLY HERE)
          Expanded(
            child: Navigator(
              key: _navigatorKey,
              onGenerateRoute: (_) =>
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
