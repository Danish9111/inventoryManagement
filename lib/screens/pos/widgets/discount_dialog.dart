import 'package:dream_pos/screens/pos/models/order_model.dart';
import 'package:dream_pos/screens/pos/pos_responsive_helper.dart';
import 'package:dream_pos/constants/appColors.dart';
import 'package:flutter/material.dart';

/// Discount Dialog for applying discounts
class DiscountDialog extends StatefulWidget {
  final double subtotal;
  final Discount? currentDiscount;
  final Function(Discount?) onApply;
  final PosResponsiveHelper responsive;

  const DiscountDialog({
    super.key,
    required this.subtotal,
    required this.currentDiscount,
    required this.onApply,
    required this.responsive,
  });

  @override
  State<DiscountDialog> createState() => _DiscountDialogState();
}

class _DiscountDialogState extends State<DiscountDialog> {
  DiscountType _selectedType = DiscountType.percentage;
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.currentDiscount != null) {
      _selectedType = widget.currentDiscount!.type;
      _valueController.text = widget.currentDiscount!.value.toString();
      _codeController.text = widget.currentDiscount!.code ?? '';
    }
  }

  double get _discountAmount {
    final value = double.tryParse(_valueController.text) ?? 0;
    if (_selectedType == DiscountType.percentage) {
      return widget.subtotal * (value / 100);
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.responsive;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive dialog size
    final dialogWidth = screenWidth < 500
        ? screenWidth * 0.9
        : r.scale(320, 400).clamp(300.0, 400.0);

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
        constraints: BoxConstraints(maxHeight: maxDialogHeight, maxWidth: 400),
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
                    SizedBox(height: r.scale(16, 24)),

                    // Discount Type Toggle
                    Text(
                      'Discount Type',
                      style: TextStyle(
                        fontSize: r.scale(12, 14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: r.scale(8, 12)),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTypeButton(
                            label: 'Percentage (%)',
                            type: DiscountType.percentage,
                            r: r,
                          ),
                        ),
                        SizedBox(width: r.scale(8, 12)),
                        Expanded(
                          child: _buildTypeButton(
                            label: 'Fixed Amount',
                            type: DiscountType.fixed,
                            r: r,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: r.scale(16, 24)),

                    // Value Input
                    Text(
                      _selectedType == DiscountType.percentage
                          ? 'Discount Percentage'
                          : 'Discount Amount',
                      style: TextStyle(
                        fontSize: r.scale(12, 14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: r.scale(8, 12)),

                    TextField(
                      controller: _valueController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        prefixText: _selectedType == DiscountType.fixed
                            ? '\$ '
                            : '',
                        suffixText: _selectedType == DiscountType.percentage
                            ? '%'
                            : '',
                        hintText: _selectedType == DiscountType.percentage
                            ? 'e.g. 10'
                            : 'e.g. 50.00',
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

                    SizedBox(height: r.scale(12, 18)),

                    // Promo Code (Optional)
                    Text(
                      'Promo Code (Optional)',
                      style: TextStyle(
                        fontSize: r.scale(12, 14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: r.scale(8, 12)),

                    TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        hintText: 'Enter promo code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(r.scale(8, 12)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: r.scale(12, 16),
                          vertical: r.scale(10, 14),
                        ),
                      ),
                    ),

                    SizedBox(height: r.scale(16, 24)),

                    // Preview
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(r.scale(12, 16)),
                      decoration: BoxDecoration(
                        color: AppColors.purchaseGreenLight,
                        borderRadius: BorderRadius.circular(r.scale(8, 12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Discount Amount:',
                            style: TextStyle(
                              fontSize: r.scale(12, 14),
                              color: AppColors.textGrey,
                            ),
                          ),
                          Text(
                            '-\$${_discountAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: r.scale(16, 20),
                              fontWeight: FontWeight.bold,
                              color: AppColors.purchaseGreen,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: r.scale(16, 24)),
                  ],
                ),
              ),
            ),

            // Fixed Footer - Buttons
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
            'Apply Discount',
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

  Widget _buildFooter(PosResponsiveHelper r) {
    return Container(
      padding: EdgeInsets.all(r.scale(12, 20)),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Row(
        children: [
          // Remove Discount Button
          if (widget.currentDiscount != null)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  widget.onApply(null);
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.expensesRed,
                  side: const BorderSide(color: AppColors.expensesRed),
                  padding: EdgeInsets.symmetric(vertical: r.scale(10, 14)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(r.scale(8, 12)),
                  ),
                ),
                child: Text(
                  'Remove',
                  style: TextStyle(
                    fontSize: r.scale(12, 14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (widget.currentDiscount != null) SizedBox(width: r.scale(10, 14)),

          // Apply Button
          Expanded(
            flex: widget.currentDiscount != null ? 2 : 1,
            child: ElevatedButton(
              onPressed: () {
                final value = double.tryParse(_valueController.text);
                if (value != null && value > 0) {
                  widget.onApply(
                    Discount(
                      type: _selectedType,
                      value: value,
                      code: _codeController.text.isNotEmpty
                          ? _codeController.text
                          : null,
                    ),
                  );
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purchaseGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: r.scale(10, 14)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(r.scale(8, 12)),
                ),
              ),
              child: Text(
                'Apply Discount',
                style: TextStyle(
                  fontSize: r.scale(12, 14),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton({
    required String label,
    required DiscountType type,
    required PosResponsiveHelper r,
  }) {
    final isSelected = _selectedType == type;
    return InkWell(
      onTap: () => setState(() => _selectedType = type),
      borderRadius: BorderRadius.circular(r.scale(8, 12)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: r.scale(10, 14)),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBlue.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(r.scale(8, 12)),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: r.scale(10, 13),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.primaryBlue : AppColors.textGrey,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    _codeController.dispose();
    super.dispose();
  }
}
