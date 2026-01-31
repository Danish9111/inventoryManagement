import 'package:dream_pos/screens/dashBoard/responsive_helper.dart';
import 'package:dream_pos/widgets/appColors.dart';
import 'package:flutter/material.dart';

/// 🔹 Summary Card Widget - Fluid Responsive
class SummaryCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final bool isAlert;
  final Color iconBgColor;
  final Color iconColor;
  final ResponsiveHelper responsive;

  const SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    this.isAlert = false,
    required this.iconBgColor,
    required this.iconColor,
    required this.responsive,
  });

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.responsive;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(r.summaryCardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r.summaryCardBorderRadius),
          border: Border.all(
            color: _isHovered
                ? widget.iconColor.withOpacity(0.4)
                : widget.iconBgColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? widget.iconColor.withOpacity(0.1)
                  : Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Icon - Fluid Size
                Container(
                  width: r.summaryIconContainerSize,
                  height: r.summaryIconContainerSize,
                  decoration: BoxDecoration(
                    color: widget.iconBgColor,
                    borderRadius: BorderRadius.circular(r.scale(10, 14)),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: r.summaryIconSize,
                  ),
                ),
                SizedBox(width: r.scale(10, 16)),
                // Title - Fluid Size
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: r.summaryLabelSize,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: r.scale(12, 22)),
            // Value - Fluid Size
            Text(
              widget.value,
              style: TextStyle(
                fontSize: r.summaryValueSize,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: r.scale(4, 10)),
            // Change Text - Fluid Size
            Row(
              children: [
                if (!widget.isAlert)
                  Icon(
                    widget.isPositive
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    size: r.scale(14, 18),
                    color: widget.isPositive
                        ? AppColors.summaryGreenText
                        : AppColors.expensesRed,
                  ),
                SizedBox(width: r.scale(2, 6)),
                Expanded(
                  child: Text(
                    widget.change,
                    style: TextStyle(
                      fontSize: r.summaryChangeSize,
                      fontWeight: FontWeight.w500,
                      color: widget.isAlert
                          ? widget.iconColor
                          : (widget.isPositive
                                ? AppColors.summaryGreenText
                                : AppColors.expensesRed),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
