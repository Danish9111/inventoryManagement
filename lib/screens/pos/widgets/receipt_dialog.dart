import 'dart:io';
import 'package:dream_pos/screens/pos/models/receipt_model.dart';
import 'package:dream_pos/screens/pos/pos_responsive_helper.dart';
import 'package:dream_pos/screens/pos/services/receipt_pdf_generator.dart';
import 'package:dream_pos/widgets/appColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

/// Receipt Dialog - Shows after successful payment
class ReceiptDialog extends StatelessWidget {
  final Receipt receipt;
  final PosResponsiveHelper responsive;
  final VoidCallback onDone;

  const ReceiptDialog({
    super.key,
    required this.receipt,
    required this.responsive,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final r = responsive;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final dialogWidth = screenWidth < 500
        ? screenWidth * 0.92
        : r.scale(380, 480).clamp(350.0, 480.0);

    final maxDialogHeight = screenHeight * 0.88;
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(r.scale(12, 18)),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: r.scale(12, 20),
        vertical: r.scale(16, 32),
      ),
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(maxHeight: maxDialogHeight),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r.scale(12, 18)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with Success Icon
            _buildHeader(r),

            // Scrollable Receipt Content
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: r.scale(16, 24)),
                  child: Column(
                    children: [
                      SizedBox(height: r.scale(12, 18)),

                      // Store Info
                      Text(
                        Receipt.storeName,
                        style: TextStyle(
                          fontSize: r.scale(18, 22),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      SizedBox(height: r.scale(2, 4)),
                      Text(
                        Receipt.storeAddress,
                        style: TextStyle(
                          fontSize: r.scale(10, 12),
                          color: AppColors.textGrey,
                        ),
                      ),
                      Text(
                        Receipt.storePhone,
                        style: TextStyle(
                          fontSize: r.scale(10, 12),
                          color: AppColors.textGrey,
                        ),
                      ),

                      SizedBox(height: r.scale(12, 16)),
                      _buildDashedDivider(r),
                      SizedBox(height: r.scale(12, 16)),

                      // Order Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order: #${receipt.orderId}',
                            style: TextStyle(
                              fontSize: r.scale(11, 13),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            dateFormat.format(receipt.timestamp),
                            style: TextStyle(
                              fontSize: r.scale(10, 12),
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: r.scale(4, 6)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Customer: ${receipt.customerName}',
                            style: TextStyle(
                              fontSize: r.scale(10, 12),
                              color: AppColors.textGrey,
                            ),
                          ),
                          Text(
                            timeFormat.format(receipt.timestamp),
                            style: TextStyle(
                              fontSize: r.scale(10, 12),
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: r.scale(12, 16)),
                      _buildDashedDivider(r),
                      SizedBox(height: r.scale(12, 16)),

                      // Items
                      ...receipt.items.map((item) => _buildItemRow(item, r)),

                      SizedBox(height: r.scale(12, 16)),
                      _buildDashedDivider(r),
                      SizedBox(height: r.scale(12, 16)),

                      // Summary
                      _buildSummaryRow(
                        'Subtotal',
                        '\$${receipt.subtotal.toStringAsFixed(2)}',
                        r,
                      ),
                      SizedBox(height: r.scale(4, 6)),
                      _buildSummaryRow(
                        'Tax (${receipt.taxRate.toStringAsFixed(0)}%)',
                        '\$${receipt.tax.toStringAsFixed(2)}',
                        r,
                      ),
                      if (receipt.discountAmount > 0) ...[
                        SizedBox(height: r.scale(4, 6)),
                        _buildSummaryRow(
                          'Discount',
                          '-\$${receipt.discountAmount.toStringAsFixed(2)}',
                          r,
                          valueColor: AppColors.purchaseGreen,
                        ),
                      ],

                      SizedBox(height: r.scale(8, 12)),
                      Divider(color: AppColors.cardBorder),
                      SizedBox(height: r.scale(8, 12)),

                      // Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'TOTAL',
                            style: TextStyle(
                              fontSize: r.scale(16, 20),
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            '\$${receipt.total.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: r.scale(18, 24),
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: r.scale(12, 16)),
                      _buildDashedDivider(r),
                      SizedBox(height: r.scale(12, 16)),

                      // Payment Info
                      _buildSummaryRow(
                        'Payment Method',
                        receipt.paymentMethod,
                        r,
                      ),
                      if (receipt.amountReceived != null) ...[
                        SizedBox(height: r.scale(4, 6)),
                        _buildSummaryRow(
                          'Amount Received',
                          '\$${receipt.amountReceived!.toStringAsFixed(2)}',
                          r,
                        ),
                      ],
                      if (receipt.change != null && receipt.change! > 0) ...[
                        SizedBox(height: r.scale(4, 6)),
                        _buildSummaryRow(
                          'Change',
                          '\$${receipt.change!.toStringAsFixed(2)}',
                          r,
                          valueColor: AppColors.purchaseGreen,
                          isBold: true,
                        ),
                      ],

                      SizedBox(height: r.scale(16, 24)),

                      // Footer Message
                      Container(
                        padding: EdgeInsets.all(r.scale(12, 16)),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundGrey,
                          borderRadius: BorderRadius.circular(r.scale(8, 12)),
                        ),
                        child: Text(
                          Receipt.footerMessage,
                          style: TextStyle(
                            fontSize: r.scale(12, 14),
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: r.scale(16, 24)),
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons Footer
            _buildFooter(context, r),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(PosResponsiveHelper r) {
    return Container(
      padding: EdgeInsets.all(r.scale(16, 24)),
      decoration: BoxDecoration(
        color: AppColors.purchaseGreen,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(r.scale(12, 18)),
          topRight: Radius.circular(r.scale(12, 18)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(r.scale(8, 12)),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: r.scale(24, 32),
            ),
          ),
          SizedBox(width: r.scale(12, 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Successful!',
                  style: TextStyle(
                    fontSize: r.scale(16, 20),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: r.scale(2, 4)),
                Text(
                  'Order #${receipt.orderId}',
                  style: TextStyle(
                    fontSize: r.scale(11, 13),
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(ReceiptItem item, PosResponsiveHelper r) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: r.scale(4, 6)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: r.scale(11, 13),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '@\$${item.unitPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: r.scale(9, 11),
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: r.scale(40, 50),
            child: Text(
              'x${item.quantity}',
              style: TextStyle(
                fontSize: r.scale(11, 13),
                color: AppColors.textGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: r.scale(60, 80),
            child: Text(
              '\$${item.totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: r.scale(11, 13),
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    PosResponsiveHelper r, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: r.scale(11, 13),
            color: AppColors.textGrey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: r.scale(11, 13),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildDashedDivider(PosResponsiveHelper r) {
    return Row(
      children: List.generate(
        50,
        (index) => Expanded(
          child: Container(
            height: 1,
            color: index.isEven ? AppColors.cardBorder : Colors.transparent,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, PosResponsiveHelper r) {
    return Container(
      padding: EdgeInsets.all(r.scale(12, 18)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Row(
        children: [
          // Print Button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _printReceipt(context),
              icon: Icon(Icons.print_rounded, size: r.scale(16, 20)),
              label: Text('Print', style: TextStyle(fontSize: r.scale(12, 14))),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                side: BorderSide(color: AppColors.primaryBlue),
                padding: EdgeInsets.symmetric(vertical: r.scale(10, 14)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(r.scale(8, 10)),
                ),
              ),
            ),
          ),
          SizedBox(width: r.scale(8, 12)),

          // Share Button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _shareReceipt(context),
              icon: Icon(Icons.share_rounded, size: r.scale(16, 20)),
              label: Text('Share', style: TextStyle(fontSize: r.scale(12, 14))),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.productsPurple,
                side: BorderSide(color: AppColors.productsPurple),
                padding: EdgeInsets.symmetric(vertical: r.scale(10, 14)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(r.scale(8, 10)),
                ),
              ),
            ),
          ),
          SizedBox(width: r.scale(8, 12)),

          // Done Button
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onDone();
              },
              icon: Icon(Icons.check_circle_rounded, size: r.scale(16, 20)),
              label: Text('Done', style: TextStyle(fontSize: r.scale(12, 14))),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purchaseGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: r.scale(10, 14)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(r.scale(8, 10)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _printReceipt(BuildContext context) async {
    try {
      final pdfGenerator = ReceiptPdfGenerator(receipt);
      final pdfData = await pdfGenerator.generate();

      await Printing.layoutPdf(
        onLayout: (format) async => pdfData,
        name: 'Receipt_${receipt.orderId}',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error printing: $e'),
            backgroundColor: AppColors.expensesRed,
          ),
        );
      }
    }
  }

  Future<void> _shareReceipt(BuildContext context) async {
    try {
      final pdfGenerator = ReceiptPdfGenerator(receipt);
      final pdfData = await pdfGenerator.generate();

      // Save to temp file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/Receipt_${receipt.orderId}.pdf');
      await file.writeAsBytes(pdfData);

      // Share
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Receipt #${receipt.orderId}',
        text: 'Thank you for your purchase at ${Receipt.storeName}!',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing: $e'),
            backgroundColor: AppColors.expensesRed,
          ),
        );
      }
    }
  }
}
