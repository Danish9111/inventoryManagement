import 'package:dream_pos/widgets/appColors.dart';
import 'package:flutter/material.dart';
import '../models/report_models.dart';
import '../reports_responsive_helper.dart';

/// Date Filter Dropdown Widget
class DateFilterWidget extends StatelessWidget {
  final DateFilterOption selectedOption;
  final Function(DateFilterOption) onChanged;
  final ReportsResponsiveHelper responsive;

  const DateFilterWidget({
    super.key,
    required this.selectedOption,
    required this.onChanged,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: responsive.dateFilterHeight,
      padding: EdgeInsets.symmetric(horizontal: responsive.dateFilterPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.dateFilterBorderRadius),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DateFilterOption>(
          dropdownColor: AppColors.white,
          value: selectedOption,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: const Color(0xFF64748B),
            size: responsive.scale(18, 22),
          ),
          style: TextStyle(
            fontSize: responsive.dateFilterFontSize,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1E293B),
          ),
          items: DateFilterOption.values.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: responsive.scale(14, 18),
                    color: const Color(0xFF64748B),
                  ),
                  SizedBox(width: responsive.scale(6, 10)),
                  Text(option.label),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}

/// Export Button Widget
class ExportButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final ReportsResponsiveHelper responsive;

  const ExportButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(responsive.dateFilterBorderRadius),
        child: Container(
          height: responsive.dateFilterHeight,
          padding: EdgeInsets.symmetric(
            horizontal: responsive.dateFilterPadding,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(
              responsive.dateFilterBorderRadius,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: responsive.scale(16, 20), color: Colors.white),
              SizedBox(width: responsive.scale(6, 10)),
              Text(
                label,
                style: TextStyle(
                  fontSize: responsive.dateFilterFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
