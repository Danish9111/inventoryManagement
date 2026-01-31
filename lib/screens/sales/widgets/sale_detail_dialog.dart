import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dream_pos/widgets/appColors.dart';
import '../models/sale_model.dart';
import '../sales_responsive_helper.dart';

/// Dialog to show sale details
class SaleDetailDialog extends StatelessWidget {
  final Sale sale;
  final SalesResponsiveHelper r;

  const SaleDetailDialog({super.key, required this.sale, required this.r});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm:ss a');

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(r.cardRadius + 4),
      ),
      child: Container(
        width: r.isCompact ? double.infinity : 500,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 1,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            // _buildHeader(context),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(r.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Info
                    _buildInfoSection('Order Information', [
                      _buildInfoRow('Order ID', sale.orderId),
                      _buildInfoRow('Date', dateFormat.format(sale.timestamp)),
                      _buildInfoRow('Time', timeFormat.format(sale.timestamp)),
                      _buildInfoRow('Customer', sale.customerName),
                      _buildInfoRow('Status', sale.statusText),
                    ]),

                    SizedBox(height: r.sectionSpacing),

                    // Items
                    _buildItemsSection(),

                    SizedBox(height: r.sectionSpacing),

                    // Payment Summary
                    _buildPaymentSummary(),
                  ],
                ),
              ),
            ),

            // Footer actions
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(r.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(r.cardRadius + 4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: Colors.white,
              size: r.iconSize + 4,
            ),
          ),
          SizedBox(width: r.itemSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sale Details',
                  style: TextStyle(
                    fontSize: r.headingSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  sale.orderId,
                  style: TextStyle(
                    fontSize: r.captionSize,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: r.bodySize + 1,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: r.itemSpacing),
        Container(
          padding: EdgeInsets.all(r.cardPadding),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(r.buttonRadius),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(children: rows),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: r.itemSpacing / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: r.bodySize, color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: r.bodySize,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Items',
              style: TextStyle(
                fontSize: r.bodySize + 1,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
            Text(
              '${sale.totalItems} items',
              style: TextStyle(
                fontSize: r.captionSize,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        SizedBox(height: r.itemSpacing),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(r.buttonRadius),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: sale.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Container(
                padding: EdgeInsets.all(r.cardPadding),
                decoration: BoxDecoration(
                  border: index < sale.items.length - 1
                      ? Border(bottom: BorderSide(color: Colors.grey.shade200))
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${item.quantity}x',
                          style: TextStyle(
                            fontSize: r.captionSize,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: r.itemSpacing),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: TextStyle(
                              fontSize: r.bodySize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '\$${item.unitPrice.toStringAsFixed(2)} each',
                            style: TextStyle(
                              fontSize: r.captionSize,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: r.bodySize,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Summary',
          style: TextStyle(
            fontSize: r.bodySize + 1,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: r.itemSpacing),
        Container(
          padding: EdgeInsets.all(r.cardPadding),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(r.buttonRadius),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildSummaryRow('Subtotal', sale.subtotal),
              _buildSummaryRow('Tax', sale.tax),
              if (sale.discount > 0)
                _buildSummaryRow('Discount', -sale.discount, isNegative: true),
              Divider(color: Colors.grey.shade300),
              _buildSummaryRow('Total', sale.total, isTotal: true),
              SizedBox(height: r.itemSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    sale.paymentIcon,
                    style: TextStyle(fontSize: r.headingSize),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Paid via ${sale.paymentMethod}',
                    style: TextStyle(
                      fontSize: r.bodySize,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    double value, {
    bool isTotal = false,
    bool isNegative = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: r.itemSpacing / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? r.bodySize + 1 : r.bodySize,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppColors.primaryBlue : Colors.grey.shade600,
            ),
          ),
          Text(
            '${isNegative ? '-' : ''}\$${value.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? r.bodySize + 1 : r.bodySize,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isNegative
                  ? AppColors.primaryOrange
                  : (isTotal ? const Color(0xFF10B981) : Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(r.cardPadding),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(r.cardRadius + 4),
        ),
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Reprint receipt
                Navigator.pop(context);
              },
              icon: Icon(Icons.print_outlined, size: r.iconSize),
              label: Text('Reprint'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                side: BorderSide(color: AppColors.primaryBlue),
                padding: EdgeInsets.symmetric(vertical: r.isCompact ? 10 : 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(r.buttonRadius),
                ),
              ),
            ),
          ),
          SizedBox(width: r.itemSpacing),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.check_rounded, size: r.iconSize),
              label: Text('Close'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: r.isCompact ? 10 : 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(r.buttonRadius),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
