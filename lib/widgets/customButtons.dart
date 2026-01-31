import 'package:flutter/material.dart';

import 'appColors.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 53,
    this.borderRadius = 12,
    this.backgroundColor = AppColors.primaryOrange,
    this.textColor = Colors.white,
    this.textSize = 16,
  });

  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final double? textSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
          ),
          elevation: 3,
          shadowColor: Colors.black26,
        ),
        onPressed: onPressed, // ✅ fixed
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: textSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class ProductTopActions extends StatelessWidget {
  final VoidCallback onRefresh;
  final VoidCallback onBack;
  final String buttonLabel;

  const ProductTopActions({
    super.key,
    required this.onRefresh,
    required this.onBack,
    this.buttonLabel = 'Back to Products',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        /// REFRESH BUTTON
        InkWell(
          onTap: onRefresh,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(Icons.refresh, size: 20, color: Colors.black87),
          ),
        ),

        const SizedBox(width: 10),

        /// BACK BUTTON
        ElevatedButton.icon(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back, size: 18),
          label: Text(buttonLabel),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
        ),
      ],
    );
  }
}
