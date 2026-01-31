import 'package:dream_pos/screens/products/ProductListScreen/productTableBody.dart';
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
          // Cell(width: 80, text: 'SKU'),
          Cell(flex: 3, text: 'Product Name'),
          Cell(flex: 2,text: 'Category'),
          Cell(flex: 2,text: 'Brand'),
          Cell(flex: 2,text: 'Price'),
          Cell(flex: 2,text: 'Unit'),
          Cell(flex: 2,text: 'Qty'),
          // Cell(flex: 2, text: 'Created By'),
          Cell(width: 120, text: 'Actions'),
        ],
      ),
    );
  }
}
