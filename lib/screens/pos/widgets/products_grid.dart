import 'package:dream_pos/screens/pos/pos_responsive_helper.dart';
import 'package:dream_pos/screens/pos/widgets/product_card.dart';
import 'package:dream_pos/widgets/appColors.dart';
import 'package:flutter/material.dart';

import '../../products/model/product.dart';

class ProductsGrid extends StatelessWidget {
  final List<Product> products;
  final Map<String, int> cartQuantities; // productId -> quantity
  final Function(Product) onAddToCart;
  final Function(String) onDecrement;
  final Function(String) onRemove; // Remove product entirely from cart
  final PosResponsiveHelper responsive;

  const ProductsGrid({
    super.key,
    required this.products,
    required this.cartQuantities,
    required this.onAddToCart,
    required this.onDecrement,
    required this.onRemove,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    final r = responsive;

    // Empty state
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: r.scale(48, 64),
              color: AppColors.textGrey.withOpacity(0.5),
            ),
            SizedBox(height: r.scale(12, 16)),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: r.scale(14, 18),
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      );
    }

    // Products grid
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: r.productGridColumns,
        crossAxisSpacing: r.gridSpacing,
        mainAxisSpacing: r.gridSpacing,
        childAspectRatio: r.productCardAspectRatio,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final quantity = cartQuantities[product.id] ?? 0;

        return ProductCard(
          product: product,
          quantity: quantity,
          isSelected: quantity > 0,
          // Toggle behavior: if in cart, remove it; else add it
          onTap: () =>
              quantity > 0 ? onRemove(product.id) : onAddToCart(product),
          onIncrement: () => onAddToCart(product),
          onDecrement: () => onDecrement(product.id),
          responsive: r,
        );
      },
    );
  }
}
