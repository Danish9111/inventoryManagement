import 'package:dream_pos/constants/appColors.dart';
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

/// Export Button Widget - Now with Dropdown Menu
class ExportButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final ReportsResponsiveHelper responsive;

  const ExportButton({
    super.key,
    required this.label,
    required this.icon,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      iconColor: Colors.white,
      color: AppColors.white,
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      onSelected: (value) {
        // Handle export selection
        debugPrint('Exporting as $value');
      },
      itemBuilder: (BuildContext context) => [
        _menuItem(
          value: 'pdf',
          icon: Icons.picture_as_pdf_rounded,
          text: 'Export as PDF',
          color: const Color(0xFFEF4444),
        ),
        _menuItem(
          value: 'excel',
          icon: Icons.table_chart_rounded,
          text: 'Export as Excel',
          color: const Color(0xFF10B981),
        ),
        _menuItem(
          value: 'share',
          icon: Icons.share_rounded,
          text: 'Share Report',
          color: const Color(0xFF3B82F6),
        ),
      ],
      child: Container(
        height: responsive.dateFilterHeight,
        padding: EdgeInsets.symmetric(horizontal: responsive.dateFilterPadding),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(
            responsive.dateFilterBorderRadius,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
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
            SizedBox(width: responsive.scale(4, 8)),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: responsive.scale(16, 20),
              color: Colors.white.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _menuItem({
    required String value,
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
