import 'package:dream_pos/screens/pos/pos_responsive_helper.dart';
import 'package:dream_pos/widgets/appColors.dart';
import 'package:flutter/material.dart';

/// Order Summary Widget showing subtotal, tax, discount, total
class OrderSummary extends StatelessWidget {
  final double subtotal;
  final double taxRate;
  final double discountAmount;
  final VoidCallback onApplyDiscount;
  final VoidCallback onPay;
  final bool hasItems;
  final PosResponsiveHelper responsive;

  const OrderSummary({
    super.key,
    required this.subtotal,
    required this.taxRate,
    required this.discountAmount,
    required this.onApplyDiscount,
    required this.onPay,
    required this.hasItems,
    required this.responsive,
  });

  double get tax => subtotal * (taxRate / 100);
  double get total => subtotal + tax - discountAmount;

  @override
  Widget build(BuildContext context) {
    final r = responsive;

    return Column(
      children: [
        // Divider
        Divider(color: AppColors.cardBorder, height: r.scale(16, 24)),

        // Summary Rows
        _buildSummaryRow('Subtotal', subtotal, r),
        SizedBox(height: r.scale(6, 10)),
        _buildSummaryRow('Tax (${taxRate.toStringAsFixed(0)}%)', tax, r),
        SizedBox(height: r.scale(6, 10)),

        // Discount Row with Apply Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Discount',
                  style: TextStyle(
                    fontSize: r.summaryLabelSize,
                    color: AppColors.textGrey,
                  ),
                ),
                SizedBox(width: r.scale(6, 10)),
                InkWell(
                  onTap: hasItems ? onApplyDiscount : null,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: r.scale(8, 12),
                      vertical: r.scale(4, 6),
                    ),
                    decoration: BoxDecoration(
                      color: hasItems
                          ? AppColors.purchaseGreen
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: r.scale(10, 12),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              '-\$${discountAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: r.summaryValueSize,
                fontWeight: FontWeight.w600,
                color: AppColors.purchaseGreen,
              ),
            ),
          ],
        ),

        Divider(color: AppColors.cardBorder, height: r.scale(20, 32)),

        // Total Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: TextStyle(
                fontSize: r.summaryTotalSize,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: r.summaryTotalSize,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ),

        SizedBox(height: r.scale(16, 24)),

        // Pay Button
        SizedBox(
          width: double.infinity,
          height: r.payButtonHeight,
          child: ElevatedButton(
            onPressed: hasItems ? onPay : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: hasItems
                  ? AppColors.purchaseGreen
                  : Colors.grey.shade300,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(r.scale(10, 14)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.payment_rounded, size: r.payButtonFontSize),
                SizedBox(width: r.scale(8, 12)),
                Text(
                  'Pay Now',
                  style: TextStyle(
                    fontSize: r.payButtonFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, double value, PosResponsiveHelper r) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: r.summaryLabelSize,
            color: AppColors.textGrey,
          ),
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: r.summaryValueSize,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
