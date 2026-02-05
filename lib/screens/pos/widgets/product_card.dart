import 'package:dream_pos/screens/pos/pos_responsive_helper.dart';
import 'package:dream_pos/constants/appColors.dart';
import 'package:flutter/material.dart';

import '../../products/model/product.dart';

/// Compact Product Card Widget for POS Grid
class ProductCard extends StatelessWidget {
  final Product product;
  final int quantity;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final PosResponsiveHelper responsive;

  const ProductCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.isSelected,
    required this.onTap,
    required this.onIncrement,
    required this.onDecrement,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    final r = responsive;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.productCardRadius),
        border: Border.all(
          color: isSelected ? AppColors.purchaseGreen : AppColors.cardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(r.productCardRadius),
          child: Padding(
            padding: EdgeInsets.all(r.productCardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image - Compact
                Expanded(
                  child: Stack(
                    children: [
                      // Image
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.contain,
                            cacheWidth: 150,
                            cacheHeight: 150,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: AppColors.backgroundGrey,
                                child: Center(
                                  child: SizedBox(
                                    width: r.scale(16, 20),
                                    height: r.scale(16, 20),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primaryBlue.withOpacity(
                                        0.4,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.backgroundGrey,
                              child: Icon(
                                Icons.image_outlined,
                                size: r.scale(24, 32),
                                color: AppColors.textGrey.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Selection badge
                      if (isSelected)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(r.scale(2, 4)),
                            decoration: const BoxDecoration(
                              color: AppColors.purchaseGreen,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: r.scale(10, 14),
                            ),
                          ),
                        ),
                      // Quantity badge
                      if (quantity > 0)
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: r.scale(5, 7),
                              vertical: r.scale(2, 3),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'x$quantity',
                              style: TextStyle(
                                fontSize: r.scale(9, 11),
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: r.scale(4, 6)),

                // Product Name
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: r.productNameSize,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: r.scale(2, 4)),

                // Price and Qty Controls Row
                Row(
                  children: [
                    // Price - Takes available space
                    Expanded(
                      child: Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: r.productPriceSize,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryBlue,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(width: r.scale(4, 8)),

                    // Compact Qty Controls - Flexible to prevent overflow
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundGrey,
                        borderRadius: BorderRadius.circular(r.scale(4, 6)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildQtyBtn(
                            Icons.remove,
                            quantity > 0 ? onDecrement : null,
                            r,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: r.scale(16, 22),
                            ),
                            child: Text(
                              '$quantity',
                              style: TextStyle(
                                fontSize: r.qtyFontSize,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          _buildQtyBtn(Icons.add, onIncrement, r),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQtyBtn(
    IconData icon,
    VoidCallback? onTap,
    PosResponsiveHelper r,
  ) {
    final disabled = onTap == null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(r.scale(4, 6)),
      child: Container(
        width: r.qtyButtonSize,
        height: r.qtyButtonSize,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: r.scale(12, 16),
          color: disabled ? Colors.grey.shade400 : AppColors.primaryBlue,
        ),
      ),
    );
  }
}
