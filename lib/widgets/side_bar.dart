import 'package:dream_pos/widgets/appColors.dart';
import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SideBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),

          _sideItem(0, Icons.dashboard_outlined, 'Dashboard'),
          _sideItem(1, Icons.point_of_sale_outlined, 'POS'),
          _sideItem(2, Icons.inventory_2_outlined, 'Products'),
          _sideItem(3, Icons.receipt, 'Sales'),
          _sideItem(4, Icons.receipt_long_outlined, 'Reports'),
          _sideItem(5, Icons.qr_code_2_rounded, 'Barcode'),
          _sideItem(6, Icons.monetization_on_outlined, 'Expenses'),
          _sideItem(7, Icons.settings_outlined, 'Settings'),
        ],
      ),
    );
  }

  Widget _sideItem(int index, IconData icon, String label) {
    final bool isActive = selectedIndex == index;

    return InkWell(
      onTap: () => onItemSelected(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? AppColors.primaryOrange : AppColors.primaryBlue,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? AppColors.primaryOrange
                    : AppColors.primaryBlue,
              ),
            ),

            // 🔴 Active underline
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: isActive ? 24 : 0,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
