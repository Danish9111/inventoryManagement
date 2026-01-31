import 'package:flutter/material.dart';
import '../models/report_models.dart';
import '../reports_responsive_helper.dart';

/// Top Products Table Widget
class ProductsTableWidget extends StatelessWidget {
  final String title;
  final List<ProductSalesData> products;
  final ReportsResponsiveHelper responsive;

  const ProductsTableWidget({
    super.key,
    required this.title,
    required this.products,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(responsive.tablePadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: responsive.chartTitleSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All →',
                    style: TextStyle(
                      fontSize: responsive.scale(12, 14),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Table Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.tablePadding,
              vertical: responsive.scale(10, 14),
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(
                top: BorderSide(color: Color(0xFFE2E8F0)),
                bottom: BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Product',
                    style: TextStyle(
                      fontSize: responsive.tableHeaderSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Category',
                    style: TextStyle(
                      fontSize: responsive.tableHeaderSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Sold',
                    style: TextStyle(
                      fontSize: responsive.tableHeaderSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Revenue',
                    style: TextStyle(
                      fontSize: responsive.tableHeaderSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(width: responsive.scale(10, 16)),
                SizedBox(
                  width: responsive.scale(24, 32),
                  child: Text(
                    '',
                    style: TextStyle(fontSize: responsive.tableHeaderSize),
                  ),
                ),
              ],
            ),
          ),
          // Table Rows
          ...products.asMap().entries.map((entry) {
            final index = entry.key;
            final product = entry.value;
            final isLast = index == products.length - 1;

            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.tablePadding,
                vertical: responsive.scale(12, 16),
              ),
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : const Border(
                        bottom: BorderSide(color: Color(0xFFF1F5F9)),
                      ),
              ),
              child: Row(
                children: [
                  // Rank Badge
                  Container(
                    width: responsive.scale(22, 28),
                    height: responsive.scale(22, 28),
                    margin: EdgeInsets.only(right: responsive.scale(10, 14)),
                    decoration: BoxDecoration(
                      color: _getRankColor(index),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: responsive.scale(10, 12),
                          fontWeight: FontWeight.bold,
                          color: index < 3
                              ? Colors.white
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                  // Product Name
                  Expanded(
                    flex: 3,
                    child: Text(
                      product.productName,
                      style: TextStyle(
                        fontSize: responsive.tableCellSize,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Category
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.scale(8, 12),
                        vertical: responsive.scale(4, 6),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(
                          responsive.scale(4, 6),
                        ),
                      ),
                      child: Text(
                        product.category,
                        style: TextStyle(
                          fontSize: responsive.scale(10, 12),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  // Quantity Sold
                  Expanded(
                    child: Text(
                      '${product.quantitySold}',
                      style: TextStyle(
                        fontSize: responsive.tableCellSize,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1E293B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Revenue
                  Expanded(
                    flex: 2,
                    child: Text(
                      '\$${product.revenue.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: responsive.tableCellSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(width: responsive.scale(10, 16)),
                  // Trend Icon
                  _buildTrendIcon(product.trend),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFB800); // Gold
      case 1:
        return const Color(0xFF94A3B8); // Silver
      case 2:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  Widget _buildTrendIcon(String trend) {
    IconData icon;
    Color color;

    switch (trend) {
      case 'up':
        icon = Icons.trending_up_rounded;
        color = const Color(0xFF10B981);
        break;
      case 'down':
        icon = Icons.trending_down_rounded;
        color = const Color(0xFFEF4444);
        break;
      default:
        icon = Icons.trending_flat_rounded;
        color = const Color(0xFF64748B);
    }

    return Icon(icon, size: responsive.scale(18, 24), color: color);
  }
}
