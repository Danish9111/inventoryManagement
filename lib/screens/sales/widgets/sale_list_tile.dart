import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dream_pos/widgets/appColors.dart';
import '../models/sale_model.dart';
import '../sales_responsive_helper.dart';

/// Individual sale list tile
class SaleListTile extends StatelessWidget {
  final Sale sale;
  final VoidCallback? onTap;
  final VoidCallback? onReprint;
  final SalesResponsiveHelper r;

  const SaleListTile({
    super.key,
    required this.sale,
    this.onTap,
    this.onReprint,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: r.isCompact ? 6 : r.itemSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.isCompact ? 10 : r.cardRadius),
        border: Border.all(color: _getStatusBorderColor(), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(r.isCompact ? 10 : r.cardRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(r.isCompact ? 10 : r.cardRadius),
          child: Padding(
            padding: EdgeInsets.all(r.isCompact ? 10 : r.cardPadding),
            child: r.isCompact ? _buildCompactLayout() : _buildExpandedLayout(),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedLayout() {
    return Row(
      children: [
        // Order info
        Expanded(flex: 2, child: _buildOrderInfo()),

        // Customer
        Expanded(flex: 2, child: _buildCustomerInfo()),

        // Items count
        Expanded(flex: 1, child: _buildItemsCount()),

        // Payment
        Expanded(flex: 1, child: _buildPaymentInfo()),

        // Total
        Expanded(flex: 1, child: _buildTotalAmount()),

        // Status
        SizedBox(width: 100, child: _buildStatusBadge()),

        // Actions
        SizedBox(width: 50, child: _buildActions()),
      ],
    );
  }

  Widget _buildCompactLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ───────────── 1️⃣ LEFT ─────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                sale.orderId,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  sale.statusText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ───────────── 2️⃣ CENTER ─────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 14,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      sale.customerName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              _buildPaymentInfo(),
            ],
          ),
        ),

        // ───────────── 3️⃣ RIGHT ─────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '\$${sale.total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: sale.status == SaleStatus.completed
                      ? const Color(0xFF10B981)
                      : Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 28,
                height: 28,
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.more_vert,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'view',
                      height: 36,
                      child: Text(
                        'View Details',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'reprint',
                      height: 36,
                      child: Text('Reprint', style: TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderInfo() {
    final timeFormat = DateFormat('hh:mm a');
    final dateFormat = DateFormat('MMM dd');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sale.orderId,
          style: TextStyle(
            fontSize: r.bodySize,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: r.captionSize + 2,
              color: Colors.grey.shade400,
            ),
            SizedBox(width: 4),
            Text(
              '${dateFormat.format(sale.timestamp)} • ${timeFormat.format(sale.timestamp)}',
              style: TextStyle(
                fontSize: r.captionSize,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomerInfo() {
    return Row(
      children: [
        Container(
          width: r.isCompact ? 28 : 32,
          height: r.isCompact ? 28 : 32,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              sale.customerName.isNotEmpty
                  ? sale.customerName[0].toUpperCase()
                  : 'W',
              style: TextStyle(
                fontSize: r.bodySize,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            sale.customerName,
            style: TextStyle(
              fontSize: r.bodySize,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsCount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${sale.totalItems}',
          style: TextStyle(
            fontSize: r.bodySize,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          'items',
          style: TextStyle(
            fontSize: r.captionSize,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo() {
    return Row(
      children: [
        Text(sale.paymentIcon, style: TextStyle(fontSize: r.bodySize + 2)),
        SizedBox(width: 6),
        Text(
          sale.paymentMethod,
          style: TextStyle(
            fontSize: r.bodySize,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalAmount() {
    return Column(
      crossAxisAlignment: r.isCompact
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          '\$${sale.total.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: r.bodySize + 1,
            fontWeight: FontWeight.bold,
            color: sale.status == SaleStatus.completed
                ? const Color(0xFF10B981)
                : Colors.grey.shade500,
            decoration: sale.status == SaleStatus.refunded
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        if (sale.discount > 0)
          Text(
            '-\$${sale.discount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: r.captionSize,
              color: AppColors.primaryOrange,
            ),
          ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.isCompact ? 8 : 10,
        vertical: r.isCompact ? 4 : 5,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(r.chipRadius),
        border: Border.all(color: _getStatusColor().withOpacity(0.3), width: 1),
      ),
      child: Center(
        child: Text(
          sale.statusText,
          style: TextStyle(
            fontSize: r.captionSize,
            fontWeight: FontWeight.w600,
            color: _getStatusColor(),
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    return PopupMenuButton<String>(
      color: Colors.white,
      icon: Icon(
        Icons.more_vert_rounded,
        size: r.iconSize,
        color: Colors.grey.shade500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              Icon(
                Icons.visibility_outlined,
                size: 18,
                color: Colors.grey.shade700,
              ),
              const SizedBox(width: 12),
              const Text('View Details'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'reprint',
          child: Row(
            children: [
              Icon(Icons.print_outlined, size: 18, color: Colors.grey.shade700),
              const SizedBox(width: 12),
              const Text('Reprint Receipt'),
            ],
          ),
        ),
        if (sale.status == SaleStatus.completed) ...[
          const PopupMenuDivider(),
          PopupMenuItem(
            value: 'refund',
            child: Row(
              children: [
                Icon(Icons.undo_rounded, size: 18, color: Colors.red.shade400),
                const SizedBox(width: 12),
                Text(
                  'Process Refund',
                  style: TextStyle(color: Colors.red.shade400),
                ),
              ],
            ),
          ),
        ],
      ],
      onSelected: (value) {
        if (value == 'reprint' && onReprint != null) {
          onReprint!();
        }
      },
    );
  }

  Color _getStatusColor() {
    switch (sale.status) {
      case SaleStatus.completed:
        return const Color(0xFF10B981);
      case SaleStatus.refunded:
        return const Color(0xFFF59E0B);
      case SaleStatus.voided:
        return const Color(0xFFEF4444);
    }
  }

  Color _getStatusBorderColor() {
    switch (sale.status) {
      case SaleStatus.completed:
        return Colors.grey.shade200;
      case SaleStatus.refunded:
        return const Color(0xFFF59E0B).withOpacity(0.3);
      case SaleStatus.voided:
        return const Color(0xFFEF4444).withOpacity(0.3);
    }
  }
}
