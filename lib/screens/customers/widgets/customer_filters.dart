import 'package:flutter/material.dart';
import '../../../constants/appColors.dart';

enum CustomerFilter { highSpender, highLoyalty, newCustomer }

enum CustomerSort {
  nameAsc,
  nameDesc,
  totalSpentDesc,
  totalSpentAsc,
  newest,
  oldest,
}

class CustomerFilters extends StatelessWidget {
  final Function(String) onSearch;
  final Set<CustomerFilter> activeFilters;
  final Function(Set<CustomerFilter>) onFiltersChanged;
  final CustomerSort sortBy;
  final Function(CustomerSort) onSortChanged;

  const CustomerFilters({
    super.key,
    required this.onSearch,
    required this.activeFilters,
    required this.onFiltersChanged,
    required this.sortBy,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: 'Search by name, email or phone...',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Colors.grey.shade400,
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primaryOrange),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Filter Menu
        PopupMenuButton<CustomerFilter>(
          offset: const Offset(0, 50),
          tooltip: 'Filter',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (filter) {
            final newFilters = Set<CustomerFilter>.from(activeFilters);
            if (newFilters.contains(filter)) {
              newFilters.remove(filter);
            } else {
              newFilters.add(filter);
            }
            onFiltersChanged(newFilters);
          },
          itemBuilder: (context) => [
            _buildFilterItem(
              CustomerFilter.highSpender,
              'High Spender (> \$1k)',
            ),
            _buildFilterItem(
              CustomerFilter.highLoyalty,
              'High Loyalty (> 100pts)',
            ),
            _buildFilterItem(
              CustomerFilter.newCustomer,
              'New Customer (< 30 days)',
            ),
          ],
          child: _filterButton(
            Icons.filter_list_rounded,
            'Filter',
            isActive: activeFilters.isNotEmpty,
          ),
        ),

        const SizedBox(width: 12),

        // Sort Menu
        PopupMenuButton<CustomerSort>(
          offset: const Offset(0, 50),
          tooltip: 'Sort',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: onSortChanged,
          initialValue: sortBy,
          itemBuilder: (context) => [
            _buildSortItem(CustomerSort.nameAsc, 'Name (A-Z)'),
            _buildSortItem(CustomerSort.nameDesc, 'Name (Z-A)'),
            _buildSortItem(CustomerSort.totalSpentDesc, 'Highest Spender'),
            _buildSortItem(CustomerSort.totalSpentAsc, 'Lowest Spender'),
            _buildSortItem(CustomerSort.newest, 'Newest First'),
            _buildSortItem(CustomerSort.oldest, 'Oldest First'),
          ],
          child: _filterButton(
            Icons.sort_rounded,
            'Sort',
            isActive:
                false, // Sort is always active/selected, no "active state" needed
          ),
        ),
      ],
    );
  }

  PopupMenuItem<CustomerFilter> _buildFilterItem(
    CustomerFilter filter,
    String label,
  ) {
    final isSelected = activeFilters.contains(filter);
    return PopupMenuItem(
      value: filter,
      child: Row(
        children: [
          Icon(
            isSelected
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
            color: isSelected ? AppColors.primaryOrange : Colors.grey.shade400,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  PopupMenuItem<CustomerSort> _buildSortItem(CustomerSort sort, String label) {
    final isSelected = sortBy == sort;
    return PopupMenuItem(
      value: sort,
      child: Row(
        children: [
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: isSelected ? AppColors.primaryOrange : Colors.grey.shade400,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.primaryOrange : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterButton(IconData icon, String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primaryOrange.withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? AppColors.primaryOrange : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isActive ? AppColors.primaryOrange : Colors.grey.shade600,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.primaryOrange : Colors.grey.shade700,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
