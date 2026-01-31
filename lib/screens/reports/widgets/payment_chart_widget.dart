import 'package:dream_pos/widgets/appColors.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/report_models.dart';
import '../reports_responsive_helper.dart';

/// Payment Breakdown Donut Chart Widget
class PaymentChartWidget extends StatelessWidget {
  final String title;
  final List<PaymentBreakdown> data;
  final ReportsResponsiveHelper responsive;

  const PaymentChartWidget({
    super.key,
    required this.title,
    required this.data,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    final totalAmount = data.fold<double>(0, (sum, item) => sum + item.amount);

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
          Text(
            title,
            style: TextStyle(
              fontSize: responsive.chartTitleSize,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          // SizedBox(height: responsive.scale(16, 28)),
          // Chart and Legend
          // responsive.useWideLayout
          Row(
            children: [
              Expanded(flex: 2, child: _buildDonutChart(totalAmount)),
              SizedBox(width: responsive.scale(5, 10)),
              Expanded(flex: 1, child: _buildLegend()),
            ],
          ),
          // : Column(
          //     children: [
          //       _buildDonutChart(totalAmount),
          //       SizedBox(height: responsive.scale(16, 24)),
          //       _buildLegend(),
          //     ],
          //   ),
          SizedBox(height: responsive.scale(16, 10)),
        ],
      ),
    );
  }

  Widget _buildDonutChart(double totalAmount) {
    final maxSize = responsive.useWideLayout
        ? responsive.scale(220, 280) // tablet / half screen
        : responsive.scale(200, 240); // mobile

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxSize, maxHeight: maxSize),
        child: AspectRatio(
          aspectRatio: 1,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            builder: (context, animValue, child) {
              return CustomPaint(
                painter: DonutChartPainter(
                  data: data,
                  animationValue: animValue,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: responsive.chartLabelSize,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      SizedBox(height: responsive.scale(4, 8)),
                      Text(
                        '\$${totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: responsive.scale(18, 24),
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: responsive.scale(12, 18)),
          child: Row(
            children: [
              Container(
                width: responsive.scale(12, 16),
                height: responsive.scale(12, 16),
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: responsive.scale(10, 14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.method,
                      style: TextStyle(
                        fontSize: responsive.scale(12, 14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    SizedBox(height: responsive.scale(2, 4)),
                    Text(
                      '\$${item.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: responsive.scale(11, 13),
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.scale(8, 12),
                  vertical: responsive.scale(4, 6),
                ),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(responsive.scale(6, 8)),
                ),
                child: Text(
                  '${item.percentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: responsive.scale(11, 13),
                    fontWeight: FontWeight.bold,
                    color: item.color,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Custom Painter for Donut Chart
class DonutChartPainter extends CustomPainter {
  final List<PaymentBreakdown> data;
  final double animationValue;

  DonutChartPainter({required this.data, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.35;
    final rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    double startAngle = -math.pi / 2; // Start from top
    final totalPercentage = data.fold<double>(
      0,
      (sum, item) => sum + item.percentage,
    );

    for (final item in data) {
      final sweepAngle =
          (item.percentage / totalPercentage) * 2 * math.pi * animationValue;

      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle + 0.02; // Small gap between segments
    }
  }

  @override
  bool shouldRepaint(DonutChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
