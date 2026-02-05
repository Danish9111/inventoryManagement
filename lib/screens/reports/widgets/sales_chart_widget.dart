import 'package:dream_pos/constants/appColors.dart';
import 'package:flutter/material.dart';
import '../models/report_models.dart';
import '../reports_responsive_helper.dart';

/// Sales Bar Chart Widget - Custom painted bar chart
class SalesChartWidget extends StatelessWidget {
  final String title;
  final List<SalesDataPoint> data;
  final ReportsResponsiveHelper responsive;
  final bool showComparison;

  const SalesChartWidget({
    super.key,
    required this.title,
    required this.data,
    required this.responsive,
    this.showComparison = true,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = data.fold<double>(
      0,
      (max, point) => point.value > max ? point.value : max,
    );

    return Container(
      padding: EdgeInsets.all(responsive.chartPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.reportCardBorderRadius),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: responsive.chartTitleSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              if (showComparison)
                Row(
                  children: [
                    _legendItem('This Week', AppColors.primaryBlue),
                    SizedBox(width: responsive.scale(12, 20)),
                    _legendItem(
                      'Last Week',
                      AppColors.primaryBlue.withOpacity(0.5),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: responsive.scale(20, 32)),
          // Chart
          SizedBox(
            height: responsive.chartHeight - 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.asMap().entries.map((entry) {
                final point = entry.value;
                final heightPercent = point.value / maxValue;
                final prevHeightPercent = point.previousValue != null
                    ? point.previousValue! / maxValue
                    : 0.0;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.scale(4, 8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Bars Container
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Previous Period Bar (faded)
                              if (showComparison && point.previousValue != null)
                                _buildBar(
                                  prevHeightPercent,
                                  AppColors.primaryBlue.withOpacity(0.5),
                                  responsive.chartBarWidth * 0.7,
                                ),
                              if (showComparison)
                                SizedBox(width: responsive.scale(2, 4)),
                              // Current Period Bar
                              _buildBar(
                                heightPercent,
                                AppColors.primaryBlue,
                                responsive.chartBarWidth,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: responsive.scale(8, 12)),
                        // Label
                        Text(
                          point.label,
                          style: TextStyle(
                            fontSize: responsive.chartLabelSize,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double heightPercent, Color color, double width) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: heightPercent),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return FractionallySizedBox(
          heightFactor: value.clamp(0.05, 1.0),
          child: Container(
            width: width,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(width / 2),
              boxShadow: color == const Color(0xFF3B82F6)
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          ),
        );
      },
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: responsive.scale(10, 14),
          height: responsive.scale(10, 14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: responsive.scale(4, 6)),
        Text(
          label,
          style: TextStyle(
            fontSize: responsive.chartLabelSize,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}
