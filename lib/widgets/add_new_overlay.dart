import 'package:dream_pos/screens/pos/pos_screen.dart';
import 'package:dream_pos/constants/appColors.dart';
import 'package:flutter/material.dart';

import '../screens/expenses/expensesListScreen/expenseListScreen.dart';
import '../screens/products/ProductListScreen/productListScreen.dart';

class AddNewOverlay {
  static OverlayEntry? _entry;

  static void show(
    BuildContext context,
    void Function(int, Widget) onNavigate,
  ) {
    if (_entry != null) return;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    _entry = OverlayEntry(
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: hide,
        child: Stack(
          children: [
            Positioned(
              top: offset.dy + 56, // 👈 under app bar
              right: 100,
              child: Material(
                color: Colors.transparent,
                child: _AddNewMenu(onNavigate: onNavigate),
              ),
            ),
          ],
        ),
      ),
    );

    overlay.insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}

class _AddNewMenu extends StatelessWidget {
  const _AddNewMenu({required this.onNavigate});

  final void Function(int, Widget) onNavigate;
  final List<_MenuItem> items = const [
    _MenuItem(Icons.inventory_2, 'Product'),
    _MenuItem(Icons.shopping_cart, 'Purchase'),
    _MenuItem(Icons.sell, 'Sale'),
    _MenuItem(Icons.receipt_long, 'Expense'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 3 / 2,
        ),
        itemBuilder: (_, i) => _MenuTile(
          item: items[i],
          onTap: () {
            if (items[i].title == 'Product') {
              onNavigate(2, const ProductListScreen()); // Products
            }
            if (items[i].title == 'Purchase') {
              onNavigate(2, const ProductListScreen()); // Products
            }
            if (items[i].title == 'Sale') {
              onNavigate(1, const PosScreen()); // POS
            }
            if (items[i].title == 'Expense') {
              onNavigate(5, const ExpenseListScreen()); // Expenses
            }
          },
        ),
      ),
    );
  }
}

class _MenuTile extends StatefulWidget {
  final _MenuItem item;
  final VoidCallback onTap;

  const _MenuTile({required this.item, required this.onTap});

  @override
  State<_MenuTile> createState() => _MenuTileState();
}

class _MenuTileState extends State<_MenuTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          AddNewOverlay.hide();
          widget.onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _hover
                ? Colors.orange.withOpacity(0.08) // 🟠 hover color
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hover ? AppColors.primaryOrange : Colors.grey.shade200,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.item.icon,
                  size: 22,
                  color: _hover ? Colors.orange : Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.item.title,
                style: TextStyle(
                  fontSize: 12,
                  color: _hover ? Colors.orange : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;

  const _MenuItem(this.icon, this.title);
}
