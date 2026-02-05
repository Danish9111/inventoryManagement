import 'package:dream_pos/constants/appColors.dart';
import 'package:flutter/material.dart';

class ProductTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool? readOnly;
  final TextInputType keyboardType;
  final VoidCallback? onTap;

  /// ✅ NEW
  final bool isForDate;
  final IconData? suffixIcon;
  final bool obscureText;

  const ProductTextField({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly,
    this.onTap,
    required this.keyboardType,
    this.isForDate = false, // default false
    this.suffixIcon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          obscureText: obscureText,
          controller: controller,
          keyboardType: keyboardType,
          readOnly: isForDate ? true : (readOnly ?? false),
          cursorColor: AppColors.primaryOrange,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF2F3F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),

            /// 📅 Calendar Icon
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(
                      suffixIcon,
                      color: AppColors.primaryOrange,
                      size: 22,
                    ),
                    onPressed: onTap,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
