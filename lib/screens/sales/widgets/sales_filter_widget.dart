import 'package:flutter/material.dart';
import 'package:dream_pos/constants/appColors.dart';
import '../sales_responsive_helper.dart';

/// Filter period options
enum SalesFilterPeriod { today, yesterday, thisWeek, thisMonth }

/// Filter bar for sales list
class SalesFilterWidget extends StatelessWidget {
  final SalesFilterPeriod selectedPeriod;
  final String? searchQuery;
  final Function(SalesFilterPeriod) onPeriodChanged;
  final Function(String) onSearchChanged;
  final SalesResponsiveHelper r;

  const SalesFilterWidget({
    super.key,
    required this.selectedPeriod,
    this.searchQuery,
    required this.onPeriodChanged,
    required this.onSearchChanged,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(r.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: r.isCompact ? _buildCompactLayout() : _buildExpandedLayout(),
    );
  }

  Widget _buildExpandedLayout() {
    return Row(
      children: [
        // Search field
        Expanded(flex: 2, child: _buildSearchField()),
        SizedBox(width: r.itemSpacing),

        // Period filters
        Expanded(flex: 3, child: _buildPeriodFilters()),
      ],
    );
  }

  Widget _buildCompactLayout() {
    return Column(
      children: [
        _buildSearchField(),
        SizedBox(height: r.itemSpacing),
        _buildPeriodFilters(),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: r.buttonHeight,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(r.buttonRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        onChanged: onSearchChanged,
        style: TextStyle(fontSize: r.bodySize),
        decoration: InputDecoration(
          hintText: 'Search by order ID or customer...',
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: r.bodySize,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: r.iconSize,
            color: Colors.grey.shade400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: SalesFilterPeriod.values.map((period) {
          return Padding(
            padding: EdgeInsets.only(right: r.itemSpacing / 2),
            child: _buildFilterChip(period),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterChip(SalesFilterPeriod period) {
    final isSelected = selectedPeriod == period;

    return InkWell(
      onTap: () => onPeriodChanged(period),
      borderRadius: BorderRadius.circular(r.chipRadius),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: r.isCompact ? 12 : 16,
          vertical: r.isCompact ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(r.chipRadius),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          _getPeriodLabel(period),
          style: TextStyle(
            fontSize: r.captionSize,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  String _getPeriodLabel(SalesFilterPeriod period) {
    switch (period) {
      case SalesFilterPeriod.today:
        return 'Today';
      case SalesFilterPeriod.yesterday:
        return 'Yesterday';
      case SalesFilterPeriod.thisWeek:
        return 'This Week';
      case SalesFilterPeriod.thisMonth:
        return 'This Month';
    }
  }
}
