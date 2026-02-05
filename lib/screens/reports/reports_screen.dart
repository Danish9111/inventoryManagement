import 'package:dream_pos/screens/reports/providers/report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/appColors.dart';
import 'data/sample_report_data.dart';
import 'models/report_models.dart';
import 'reports_responsive_helper.dart';
import 'widgets/date_filter_widget.dart';
import 'widgets/stat_card_widget.dart';
import 'widgets/sales_chart_widget.dart';
import 'widgets/payment_chart_widget.dart';
import 'widgets/products_table_widget.dart';

/// 📊 Reports Screen
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  DateFilterOption _selectedDateFilter = DateFilterOption.thisWeek;
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundGrey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final responsive = ReportsResponsiveHelper(constraints.maxWidth);

          return FadeTransition(
            opacity: _fade,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.horizontalPadding,
                vertical: responsive.verticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReportsHeader(
                    responsive: responsive,
                    selectedDateFilter: _selectedDateFilter,
                    onDateChanged: (v) =>
                        setState(() => _selectedDateFilter = v),
                  ),
                  SizedBox(height: responsive.reportSectionSpacing),

                  ReportsStatsSection(responsive: responsive),
                  SizedBox(height: responsive.reportSectionSpacing),

                  ReportsChartsSection(responsive: responsive),
                  SizedBox(height: responsive.reportSectionSpacing),

                  ProductsTableWidget(
                    title: 'Top Selling Products',
                    products: SampleReportData.topProducts,
                    responsive: responsive,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/* ───────────────────────── HEADER ───────────────────────── */

class ReportsHeader extends ConsumerWidget {
  final ReportsResponsiveHelper responsive;
  final DateFilterOption selectedDateFilter;
  final ValueChanged<DateFilterOption> onDateChanged;

  const ReportsHeader({
    super.key,
    required this.responsive,
    required this.selectedDateFilter,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = responsive;

    return r.useWideLayout
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_title(r), _filters(r)],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title(r),
              SizedBox(height: r.scale(16, 20)),
              _filters(r),
            ],
          );
  }

  Widget _title(ReportsResponsiveHelper r) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(r.scale(8, 12)),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
            ),
            borderRadius: BorderRadius.circular(r.scale(10, 14)),
          ),
          child: Icon(
            Icons.analytics_rounded,
            color: Colors.white,
            size: r.scale(22, 30),
          ),
        ),
        SizedBox(width: r.scale(12, 18)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reports & Analytics',
              style: TextStyle(
                fontSize: r.reportHeaderTitleSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Track your business performance',
              style: TextStyle(
                fontSize: r.reportHeaderSubtitleSize,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _filters(ReportsResponsiveHelper r) {
    return Wrap(
      spacing: r.scale(10, 16),
      children: [
        DateFilterWidget(
          selectedOption: selectedDateFilter,
          onChanged: onDateChanged,
          responsive: r,
        ),
        ExportButton(
          label: 'Export',
          icon: Icons.download_rounded,
          responsive: r,
        ),
      ],
    );
  }
}

/* ───────────────────────── STATS ───────────────────────── */

class ReportsStatsSection extends ConsumerWidget {
  final ReportsResponsiveHelper responsive;

  const ReportsStatsSection({super.key, required this.responsive});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final stats = SampleReportData.todayStats;
    final reportsState = ref.watch(reportsProvider);
    final stats = reportsState.stats;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: responsive.statCardColumns,
        crossAxisSpacing: responsive.reportCardSpacing,
        mainAxisSpacing: responsive.reportCardSpacing,
        mainAxisExtent: responsive.statCardHeight,
      ),
      itemCount: stats.length,
      itemBuilder: (_, i) =>
          StatCardWidget(stat: stats[i], responsive: responsive),
    );
  }
}

/* ───────────────────────── CHARTS ───────────────────────── */

class ReportsChartsSection extends ConsumerWidget {
  final ReportsResponsiveHelper responsive;

  const ReportsChartsSection({super.key, required this.responsive});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsState = ref.watch(reportsProvider);
    if (responsive.useExtraWideLayout) {
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: SalesChartWidget(
              title: 'Weekly Sales Overview',
              data: reportsState.weeklySales,
              responsive: responsive,
            ),
          ),
          SizedBox(width: responsive.reportCardSpacing),
          Expanded(
            flex: 3,
            child: PaymentChartWidget(
              title: 'Payment Methods',
              data: reportsState.paymentBackground,
              responsive: responsive,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        SalesChartWidget(
          title: 'Weekly Sales Overview',
          data: reportsState.weeklySales,
          responsive: responsive,
        ),
        SizedBox(height: responsive.reportCardSpacing),
        PaymentChartWidget(
          title: 'Payment Methods',
          data: reportsState.paymentBackground,
          responsive: responsive,
        ),
      ],
    );
  }
}
