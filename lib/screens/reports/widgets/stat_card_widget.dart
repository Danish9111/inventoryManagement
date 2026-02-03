import 'package:dream_pos/widgets/appColors.dart';
import 'package:flutter/material.dart';
import '../models/report_models.dart';
import '../reports_responsive_helper.dart';

/// KPI Stat Card Widget - Displays key metrics
class StatCardWidget extends StatelessWidget {
  final Stat stat;
  final ReportsResponsiveHelper responsive;

  const StatCardWidget({
    super.key,
    required this.stat,
    required this.responsive,
  });

  /// Map icon based on stat label
  IconData get _icon {
    final label = stat.label.toLowerCase();
    if (label.contains('revenue') || label.contains('sales')) {
      return Icons.attach_money_rounded;
    } else if (label.contains('order')) {
      return Icons.receipt_long_rounded;
    } else if (label.contains('avg') || label.contains('average')) {
      return Icons.shopping_cart_rounded;
    } else if (label.contains('item') || label.contains('sold')) {
      return Icons.inventory_rounded;
    } else if (label.contains('profit')) {
      return Icons.trending_up_rounded;
    }
    return Icons.analytics_rounded;
  }

  /// Map colors based on stat label
  Color get _iconColor {
    final label = stat.label.toLowerCase();
    if (label.contains('revenue') || label.contains('sales')) {
      return AppColors.purchaseGreen;
    } else if (label.contains('order')) {
      return AppColors.primaryBlue;
    } else if (label.contains('avg') || label.contains('average')) {
      return AppColors.productsPurple;
    } else if (label.contains('item') || label.contains('sold')) {
      return AppColors.primaryOrange;
    } else if (label.contains('profit')) {
      return AppColors.purchaseGreen;
    }
    return AppColors.primaryBlue;
  }

  Color get _bgColor => _iconColor.withOpacity(0.12);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(responsive.statCardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.reportCardBorderRadius),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: responsive.statCardIconContainerSize,
            height: responsive.statCardIconContainerSize,
            decoration: BoxDecoration(
              color: _bgColor,
              borderRadius: BorderRadius.circular(
                responsive.statCardIconContainerSize * 0.3,
              ),
            ),
            child: Icon(
              _icon,
              size: responsive.statCardIconSize,
              color: _iconColor,
            ),
          ),
          SizedBox(width: responsive.scale(12, 18)),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat.label,
                  style: TextStyle(
                    fontSize: responsive.statCardLabelSize,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: responsive.scale(4, 4)),
                Text(
                  stat.value,
                  style: TextStyle(
                    fontSize: responsive.statCardValueSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                if (stat.change != null) ...[
                  SizedBox(height: responsive.scale(4, 6)),
                  Row(
                    children: [
                      Icon(
                        stat.isPositive
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        size: responsive.statCardChangeSize + 2,
                        color: stat.isPositive
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                      ),
                      SizedBox(width: responsive.scale(3, 5)),
                      Text(
                        stat.change!,
                        style: TextStyle(
                          fontSize: responsive.statCardChangeSize,
                          fontWeight: FontWeight.w600,
                          color: stat.isPositive
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
