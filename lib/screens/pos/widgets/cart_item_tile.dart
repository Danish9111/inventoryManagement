import 'package:dream_pos/screens/pos/models/cart_item_model.dart';
import 'package:dream_pos/screens/pos/pos_responsive_helper.dart';
import 'package:dream_pos/constants/appColors.dart';
import 'package:flutter/material.dart';

/// Cart Item Tile Widget for Order Panel - Compact Design
class CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;
  final PosResponsiveHelper responsive;

  const CartItemTile({
    super.key,
    required this.cartItem,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    final r = responsive;

    return Container(
      margin: EdgeInsets.only(bottom: r.scale(6, 10)),
      padding: EdgeInsets.symmetric(
        horizontal: r.scale(8, 12),
        vertical: r.scale(8, 10),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.scale(6, 10)),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          // Delete Button - Small
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              width: r.scale(22, 28),
              height: r.scale(22, 28),
              decoration: BoxDecoration(
                color: AppColors.expensesRedLight,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.delete_outline,
                size: r.scale(12, 16),
                color: AppColors.expensesRed,
              ),
            ),
          ),

          SizedBox(width: r.scale(8, 10)),

          // Product Name - Takes remaining space
          Expanded(
            child: Text(
              cartItem.product.name,
              style: TextStyle(
                fontSize: r.scale(11, 13),
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(width: r.scale(6, 8)),

          // Quantity Controls - Compact
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(r.scale(4, 6)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildQtyButton(
                  icon: Icons.remove,
                  onTap: cartItem.quantity > 1 ? onDecrement : onRemove,
                  r: r,
                ),
                Container(
                  width: r.scale(20, 26),
                  alignment: Alignment.center,
                  child: Text(
                    '${cartItem.quantity}',
                    style: TextStyle(
                      fontSize: r.scale(11, 13),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                _buildQtyButton(icon: Icons.add, onTap: onIncrement, r: r),
              ],
            ),
          ),

          SizedBox(width: r.scale(8, 10)),

          // Price - Compact fixed width
          SizedBox(
            width: r.scale(50, 65),
            child: Text(
              '\$${cartItem.totalPrice.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: r.scale(11, 13),
                fontWeight: FontWeight.w700,
                color: AppColors.primaryBlue,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton({
    required IconData icon,
    required VoidCallback onTap,
    required PosResponsiveHelper r,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(r.scale(4, 6)),
      child: Container(
        width: r.scale(22, 28),
        height: r.scale(22, 28),
        alignment: Alignment.center,
        child: Icon(icon, size: r.scale(12, 16), color: AppColors.primaryBlue),
      ),
    );
  }
}
