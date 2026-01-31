import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../widgets/appColors.dart';
import 'data/sample_sales_data.dart';
import 'models/sale_model.dart';
import 'sales_responsive_helper.dart';
import 'widgets/sale_detail_dialog.dart';
import 'widgets/sale_list_tile.dart';
import 'widgets/sales_filter_widget.dart';
import 'providers/sales_provider.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  SalesFilterPeriod _selectedPeriod = SalesFilterPeriod.today;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onPeriodChanged(SalesFilterPeriod period) {
    setState(() {
      _selectedPeriod = period;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _showSaleDetails(Sale sale, SalesResponsiveHelper r) {
    showDialog(
      context: context,
      builder: (_) => SaleDetailDialog(sale: sale, r: r),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = SalesResponsiveHelper(context);
    final allSales = ref.watch(salesProvider);

    // Apply Filters
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    List<Sale> filteredSales = allSales.where((sale) {
      // Apply date filter
      bool matchesDate = true;
      final saleDate = DateTime(
        sale.timestamp.year,
        sale.timestamp.month,
        sale.timestamp.day,
      );

      switch (_selectedPeriod) {
        case SalesFilterPeriod.today:
          matchesDate = saleDate == today;
          break;
        case SalesFilterPeriod.yesterday:
          matchesDate = saleDate == today.subtract(const Duration(days: 1));
          break;
        case SalesFilterPeriod.thisWeek:
          final weekStart = today.subtract(Duration(days: today.weekday - 1));
          matchesDate = saleDate.isAfter(
            weekStart.subtract(const Duration(days: 1)),
          );
          break;
        case SalesFilterPeriod.thisMonth:
          matchesDate =
              saleDate.year == now.year && saleDate.month == now.month;
          break;
      }

      // Apply search filter
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        matchesSearch =
            sale.orderId.toLowerCase().contains(query) ||
            sale.customerName.toLowerCase().contains(query);
      }

      return matchesDate && matchesSearch;
    }).toList();

    // Sort by most recent first
    filteredSales.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    final todaySummary = SampleSalesData.getTodaySummary(allSales);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(r.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sales History',
                            style: TextStyle(
                              fontSize: r.titleSize,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            DateFormat(
                              'EEEE, MMMM d, yyyy',
                            ).format(DateTime.now()),
                            style: TextStyle(
                              fontSize: r.bodySize,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      // Quick action buttons
                      Row(
                        children: [
                          _buildActionButton(
                            icon: Icons.download_rounded,
                            label: 'Export',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Export feature coming soon!',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                            r: r,
                            isAccent: true,
                          ),
                          SizedBox(width: r.itemSpacing),
                          _buildActionButton(
                            icon: Icons.refresh_rounded,
                            label: 'Refresh',
                            onTap: () {
                              ref.refresh(salesProvider);
                            },
                            r: r,
                          ),
                        ],
                      ),
                    ],
                  ),

                  // SizedBox(height: r.sectionSpacing),

                  // Stats Cards
                  // SalesStatsWidget(
                  //   salesCount: todaySummary['count'] as int,
                  //   revenue: todaySummary['revenue'] as double,
                  //   itemsSold: todaySummary['items'] as int,
                  //   avgOrderValue: todaySummary['average'] as double,
                  //   r: r,
                  // ),
                  SizedBox(height: r.sectionSpacing),

                  // Filter Bar
                  SalesFilterWidget(
                    selectedPeriod: _selectedPeriod,
                    searchQuery: _searchController.text,
                    onPeriodChanged: _onPeriodChanged,
                    onSearchChanged: _onSearchChanged,
                    r: r,
                  ),

                  SizedBox(height: r.sectionSpacing),

                  // List Header
                  if (!r.isCompact) _buildListHeader(r),
                ],
              ),
            ),
          ),

          // Sales List
          filteredSales.isEmpty
              ? SliverFillRemaining(child: _buildEmptyState(r))
              : SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: r.pagePadding),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final sale = filteredSales[index];
                      return SaleListTile(
                        sale: sale,
                        r: r,
                        onTap: () => _showSaleDetails(sale, r),
                      );
                    }, childCount: filteredSales.length),
                  ),
                ),

          // Bottom padding
          // SliverToBoxAdapter(child: SizedBox(height: r.pagePadding * 2)),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required SalesResponsiveHelper r,
    bool isAccent = false,
  }) {
    final color = isAccent ? AppColors.primaryOrange : AppColors.primaryBlue;

    return Material(
      color: isAccent ? AppColors.primaryOrange.withOpacity(0.1) : Colors.white,
      borderRadius: BorderRadius.circular(r.buttonRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(r.buttonRadius),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: r.cardPadding,
            vertical: r.isCompact ? 8 : 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(r.buttonRadius),
            border: Border.all(
              color: isAccent
                  ? AppColors.primaryOrange.withOpacity(0.3)
                  : Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: r.iconSize, color: color),
              if (!r.isCompact) ...[
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: r.bodySize,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListHeader(SalesResponsiveHelper r) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.cardPadding,
        vertical: r.itemSpacing,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(r.buttonRadius),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Order',
              style: TextStyle(
                fontSize: r.captionSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Customer',
              style: TextStyle(
                fontSize: r.captionSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Items',
              style: TextStyle(
                fontSize: r.captionSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Payment',
              style: TextStyle(
                fontSize: r.captionSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Total',
              style: TextStyle(
                fontSize: r.captionSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              'Status',
              style: TextStyle(
                fontSize: r.captionSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              '',
              style: TextStyle(
                fontSize: r.captionSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(SalesResponsiveHelper r) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: r.statIconSize * 2,
              color: Colors.grey.shade400,
            ),
          ),
          SizedBox(height: r.sectionSpacing),
          Text(
            'No sales found',
            style: TextStyle(
              fontSize: r.headingSize,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: r.itemSpacing),
          Text(
            'Try adjusting your filters or date range',
            style: TextStyle(fontSize: r.bodySize, color: Colors.grey.shade500),
          ),
          SizedBox(height: r.sectionSpacing),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _selectedPeriod = SalesFilterPeriod.today;
                _searchQuery = '';
                _searchController.clear();
              });
            },
            icon: const Icon(Icons.filter_alt_off_rounded),
            label: const Text('Clear Filters'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: r.cardPadding * 1.5,
                vertical: r.itemSpacing,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(r.buttonRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
