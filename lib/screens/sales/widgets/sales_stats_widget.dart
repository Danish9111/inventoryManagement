import 'package:flutter/material.dart';
import 'package:dream_pos/constants/appColors.dart';
import '../sales_responsive_helper.dart';

/// Quick stats cards showing today's summary
class SalesStatsWidget extends StatelessWidget {
  final int salesCount;
  final double revenue;
  final int itemsSold;
  final double avgOrderValue;
  final SalesResponsiveHelper r;

  const SalesStatsWidget({
    super.key,
    required this.salesCount,
    required this.revenue,
    required this.itemsSold,
    required this.avgOrderValue,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: r.itemSpacing,
      runSpacing: r.itemSpacing,
      children: [
        _buildStatCard(
          icon: Icons.receipt_long_rounded,
          iconColor: AppColors.primaryBlue,
          label: "Today's Sales",
          value: salesCount.toString(),
          gradient: [
            AppColors.primaryBlue.withOpacity(0.1),
            AppColors.primaryBlue.withOpacity(0.05),
          ],
        ),
        _buildStatCard(
          icon: Icons.attach_money_rounded,
          iconColor: const Color(0xFF10B981),
          label: 'Revenue',
          value: '\$${revenue.toStringAsFixed(2)}',
          gradient: [
            const Color(0xFF10B981).withOpacity(0.1),
            const Color(0xFF10B981).withOpacity(0.05),
          ],
        ),
        _buildStatCard(
          icon: Icons.inventory_2_outlined,
          iconColor: const Color(0xFF8B5CF6),
          label: 'Items Sold',
          value: itemsSold.toString(),
          gradient: [
            const Color(0xFF8B5CF6).withOpacity(0.1),
            const Color(0xFF8B5CF6).withOpacity(0.05),
          ],
        ),
        _buildStatCard(
          icon: Icons.trending_up_rounded,
          iconColor: AppColors.primaryOrange,
          label: 'Avg. Order',
          value: '\$${avgOrderValue.toStringAsFixed(2)}',
          gradient: [
            AppColors.primaryOrange.withOpacity(0.1),
            AppColors.primaryOrange.withOpacity(0.05),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required List<Color> gradient,
  }) {
    return Container(
      width: r.statsCardWidth,
      height: r.statsCardHeight,
      padding: EdgeInsets.all(r.cardPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(r.cardRadius),
        border: Border.all(color: iconColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(r.isCompact ? 6 : 8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: r.iconSize, color: iconColor),
              ),
              const Spacer(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: r.headingSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: r.captionSize,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
