import 'package:flutter/material.dart';

import '../../../widgets/appColors.dart';

class ProductSection extends StatelessWidget {
  final String title;
  final Widget child;

  const ProductSection({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryOrange,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
