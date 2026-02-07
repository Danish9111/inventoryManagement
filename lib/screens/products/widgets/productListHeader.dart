import 'package:dream_pos/screens/products/add_product_screen.dart';
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
              'Product List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Manage your products',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        const Spacer(),
        const SizedBox(width: 8),
        CustomElevatedButton(
          text: 'Add Product',
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => AddProductScreen()));
          },
          width: 135,
          height: 40,
          textSize: 14,
        ),
      ],
    );
  }
}
