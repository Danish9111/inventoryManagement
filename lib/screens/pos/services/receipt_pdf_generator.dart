import 'dart:typed_data';
import 'package:dream_pos/screens/pos/models/receipt_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

/// PDF Receipt Generator
class ReceiptPdfGenerator {
  final Receipt receipt;

  ReceiptPdfGenerator(this.receipt);

  /// Generate PDF document
  Future<Uint8List> generate() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80, // Thermal receipt width
        margin: const pw.EdgeInsets.all(10),
        build: (context) => _buildReceipt(),
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildReceipt() {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        // Store Header
        pw.Text(
          Receipt.storeName,
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(Receipt.storeAddress, style: const pw.TextStyle(fontSize: 8)),
        pw.Text(Receipt.storePhone, style: const pw.TextStyle(fontSize: 8)),

        pw.SizedBox(height: 8),
        _buildDivider(),
        pw.SizedBox(height: 8),

        // Order Info
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Order: #${receipt.orderId}',
              style: const pw.TextStyle(fontSize: 9),
            ),
            pw.Text(
              dateFormat.format(receipt.timestamp),
              style: const pw.TextStyle(fontSize: 9),
            ),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Customer: ${receipt.customerName}',
              style: const pw.TextStyle(fontSize: 9),
            ),
            pw.Text(
              timeFormat.format(receipt.timestamp),
              style: const pw.TextStyle(fontSize: 9),
            ),
          ],
        ),

        pw.SizedBox(height: 8),
        _buildDivider(),
        pw.SizedBox(height: 8),

        // Items Header
        pw.Row(
          children: [
            pw.Expanded(
              flex: 3,
              child: pw.Text(
                'Item',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(
              width: 30,
              child: pw.Text(
                'Qty',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.SizedBox(
              width: 50,
              child: pw.Text(
                'Total',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.right,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 4),

        // Items
        ...receipt.items.map(
              (item) =>
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 2),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            item.name,
                            style: const pw.TextStyle(fontSize: 9),
                            maxLines: 2,
                          ),
                          pw.Text(
                            '@\$${item.unitPrice.toStringAsFixed(2)}',
                            style: const pw.TextStyle(
                              fontSize: 7,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(
                      width: 30,
                      child: pw.Text(
                        '${item.quantity}',
                        style: const pw.TextStyle(fontSize: 9),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.SizedBox(
                      width: 50,
                      child: pw.Text(
                        '\$${item.totalPrice.toStringAsFixed(2)}',
                        style: const pw.TextStyle(fontSize: 9),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
        ),

        pw.SizedBox(height: 8),
        _buildDivider(),
        pw.SizedBox(height: 8),

        // Summary
        _buildSummaryRow(
          'Subtotal',
          '\$${receipt.subtotal.toStringAsFixed(2)}',
        ),
        _buildSummaryRow(
          'Tax (${receipt.taxRate.toStringAsFixed(0)}%)',
          '\$${receipt.tax.toStringAsFixed(2)}',
        ),
        if (receipt.discountAmount > 0)
          _buildSummaryRow(
            'Discount',
            '-\$${receipt.discountAmount.toStringAsFixed(2)}',
            isGreen: true,
          ),

        pw.SizedBox(height: 4),
        _buildDivider(),
        pw.SizedBox(height: 4),

        // Total
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'TOTAL',
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              '\$${receipt.total.toStringAsFixed(2)}',
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),

        pw.SizedBox(height: 8),
        _buildDivider(),
        pw.SizedBox(height: 8),

        // Payment Info
        _buildSummaryRow('Payment', receipt.paymentMethod),
        if (receipt.amountReceived != null)
          _buildSummaryRow(
            'Received',
            '\$${receipt.amountReceived!.toStringAsFixed(2)}',
          ),
        if (receipt.change != null && receipt.change! > 0)
          _buildSummaryRow(
            'Change',
            '\$${receipt.change!.toStringAsFixed(2)}',
            isBold: true,
          ),

        pw.SizedBox(height: 16),

        // Footer
        pw.Center(
          child: pw.Text(
            Receipt.footerMessage,
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Center(
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.code128(),
            data: receipt.orderId,
            width: 120,
            height: 30,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildDivider() {
    return pw.Container(
      width: double.infinity,
      height: 1,
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(style: pw.BorderStyle.dashed, width: 0.5),
        ),
      ),
    );
  }

  pw.Widget _buildSummaryRow(String label,
      String value, {
        bool isGreen = false,
        bool isBold = false,
      }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: isBold ? pw.FontWeight.bold : null,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: isBold ? pw.FontWeight.bold : null,
              color: isGreen ? PdfColors.green700 : null,
            ),
          ),
        ],
      ),
    );
  }
}
