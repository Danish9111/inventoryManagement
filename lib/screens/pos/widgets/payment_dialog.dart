import 'package:dream_pos/screens/pos/pos_responsive_helper.dart';
import 'package:dream_pos/constants/appColors.dart';
import 'package:flutter/material.dart';

/// Payment Dialog for selecting payment method and completing sale
class PaymentDialog extends StatefulWidget {
  final double total;
  final double subtotal;
  final double tax;
  final double discount;
  final int itemCount;
  final Function(String paymentMethod, {double? amountReceived})
  onPaymentComplete;
  final PosResponsiveHelper responsive;

  const PaymentDialog({
    super.key,
    required this.total,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.itemCount,
    required this.onPaymentComplete,
    required this.responsive,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  String _selectedMethod = 'Cash';
  final TextEditingController _amountController = TextEditingController();
  double _change = 0;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'Cash',
      'icon': Icons.payments_outlined,
      'color': AppColors.purchaseGreen,
    },
    {
      'name': 'Card',
      'icon': Icons.credit_card_rounded,
      'color': AppColors.primaryBlue,
    },
    {
      'name': 'Mobile',
      'icon': Icons.phone_android_rounded,
      'color': AppColors.productsPurple,
    },
    {
      'name': 'Split',
      'icon': Icons.call_split_rounded,
      'color': AppColors.primaryOrange,
    },
  ];

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.total.toStringAsFixed(2);
  }

  void _calculateChange() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    setState(() {
      _change = amount - widget.total;
      if (_change < 0) _change = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.responsive;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive dialog size
    final dialogWidth = screenWidth < 500
        ? screenWidth * 0.9
        : r.scale(350, 450).clamp(300.0, 450.0);

    final maxDialogHeight = screenHeight * 0.85;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(r.scale(12, 20)),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: r.scale(16, 24),
        vertical: r.scale(24, 40),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(r.scale(12, 20)),
        ),
        width: dialogWidth,
        constraints: BoxConstraints(maxHeight: maxDialogHeight, maxWidth: 450),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Fixed Header
            _buildHeader(r),

            // Scrollable Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: r.scale(16, 24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: r.scale(12, 20)),

                    // Total Display
                    _buildTotalDisplay(r),

                    SizedBox(height: r.scale(16, 24)),

                    // Payment Methods
                    _buildPaymentMethods(r),

                    // Cash Amount Input (only for Cash)
                    if (_selectedMethod == 'Cash') _buildCashInput(r),

                    SizedBox(height: r.scale(16, 24)),
                  ],
                ),
              ),
            ),

            // Fixed Footer - Complete Button
            _buildFooter(r),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(PosResponsiveHelper r) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        r.scale(16, 24),
        r.scale(12, 16),
        r.scale(8, 12),
        r.scale(8, 12),
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Payment',
            style: TextStyle(
              fontSize: r.scale(18, 22),
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            iconSize: r.scale(18, 22),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalDisplay(PosResponsiveHelper r) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.scale(12, 20)),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(r.scale(10, 14)),
      ),
      child: Column(
        children: [
          Text(
            'Total Amount',
            style: TextStyle(fontSize: r.scale(11, 13), color: Colors.white70),
          ),
          SizedBox(height: r.scale(4, 8)),
          Text(
            '\$${widget.total.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: r.scale(24, 32),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: r.scale(4, 6)),
          Text(
            '${widget.itemCount} items',
            style: TextStyle(fontSize: r.scale(10, 12), color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods(PosResponsiveHelper r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: TextStyle(
            fontSize: r.scale(12, 14),
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: r.scale(10, 14)),
        Row(
          children: _paymentMethods.map((method) {
            final isSelected = _selectedMethod == method['name'];
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedMethod = method['name']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: r.scale(2, 4)),
                  padding: EdgeInsets.symmetric(vertical: r.scale(10, 14)),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (method['color'] as Color).withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(r.scale(8, 12)),
                    border: Border.all(
                      color: isSelected
                          ? method['color'] as Color
                          : AppColors.cardBorder,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        method['icon'] as IconData,
                        color: isSelected
                            ? method['color'] as Color
                            : AppColors.textGrey,
                        size: r.scale(18, 24),
                      ),
                      SizedBox(height: r.scale(4, 6)),
                      Text(
                        method['name'] as String,
                        style: TextStyle(
                          fontSize: r.scale(9, 11),
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? method['color'] as Color
                              : AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCashInput(PosResponsiveHelper r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: r.scale(16, 24)),
        Text(
          'Amount Received',
          style: TextStyle(
            fontSize: r.scale(12, 14),
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: r.scale(8, 12)),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          onChanged: (_) => _calculateChange(),
          decoration: InputDecoration(
            prefixText: '\$ ',
            prefixStyle: TextStyle(
              fontSize: r.scale(14, 18),
              fontWeight: FontWeight.w600,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(r.scale(8, 12)),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: r.scale(12, 16),
              vertical: r.scale(10, 14),
            ),
          ),
          style: TextStyle(
            fontSize: r.scale(14, 18),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: r.scale(10, 14)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: r.scale(12, 16),
            vertical: r.scale(10, 14),
          ),
          decoration: BoxDecoration(
            color: AppColors.purchaseGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(r.scale(8, 12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Change',
                style: TextStyle(
                  fontSize: r.scale(12, 14),
                  color: AppColors.textDark,
                ),
              ),
              Text(
                '\$${_change.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: r.scale(16, 20),
                  fontWeight: FontWeight.bold,
                  color: AppColors.purchaseGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(PosResponsiveHelper r) {
    return Container(
      padding: EdgeInsets.all(r.scale(12, 20)),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: r.scale(42, 52),
        child: ElevatedButton(
          onPressed: () {
            final amountReceived = _selectedMethod == 'Cash'
                ? double.tryParse(_amountController.text)
                : null;
            widget.onPaymentComplete(
              _selectedMethod,
              amountReceived: amountReceived,
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.purchaseGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(r.scale(8, 12)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded, size: r.scale(18, 22)),
              SizedBox(width: r.scale(6, 10)),
              Text(
                'Complete Sale',
                style: TextStyle(
                  fontSize: r.scale(14, 16),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
