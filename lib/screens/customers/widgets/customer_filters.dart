import 'package:flutter/material.dart';
import '../../../widgets/appColors.dart';

enum CustomerFilter { highSpender, highLoyalty, newCustomer }

enum CustomerSort {
  nameAsc,
  nameDesc,
  totalSpentDesc,
  totalSpentAsc,
  newest,
  oldest,
}

String _filterLabel(CustomerFilter filter) {
  switch (filter) {
    case CustomerFilter.highSpender:
      return 'High spenders';
    case CustomerFilter.highLoyalty:
      return 'High loyalty';
    case CustomerFilter.newCustomer:
      return 'New customers';
  }
}

String _sortLabel(CustomerSort sort) {
  switch (sort) {
    case CustomerSort.nameAsc:
      return 'Name (A-Z)';
    case CustomerSort.nameDesc:
      return 'Name (Z-A)';
    case CustomerSort.totalSpentDesc:
      return 'Total spent (high → low)';
    case CustomerSort.totalSpentAsc:
      return 'Total spent (low → high)';
    case CustomerSort.newest:
      return 'Newest first';
    case CustomerSort.oldest:
      return 'Oldest first';
  }
}

class CustomerFilters extends StatelessWidget {
  final ValueChanged<String> onSearch;
  final Set<CustomerFilter> activeFilters;
  final ValueChanged<Set<CustomerFilter>> onFiltersChanged;
  final CustomerSort sortBy;
  final ValueChanged<CustomerSort> onSortChanged;

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
        _filterMenu(context),
        const SizedBox(width: 12),
        _sortMenu(context),
      ],
    );
  }

  Widget _filterMenu(BuildContext context) {
    return PopupMenuButton<String>(
      color: AppColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tooltip: 'Filters',
      onSelected: (value) {
        if (value == 'clear') {
          onFiltersChanged({});
          return;
        }
        final filter = CustomerFilter.values.firstWhere(
          (f) => f.toString() == value,
        );
        final updated = {...activeFilters};
        if (updated.contains(filter)) {
          updated.remove(filter);
        } else {
          updated.add(filter);
        }
        onFiltersChanged(updated);
      },
      itemBuilder: (context) {
        return [
          ...CustomerFilter.values.map((filter) {
            final isSelected = activeFilters.contains(filter);
            return CheckedPopupMenuItem<String>(
              value: filter.toString(),
              checked: isSelected,
              child: Text(_filterLabel(filter)),
            );
          }),
          const PopupMenuDivider(),
          const PopupMenuItem<String>(
            value: 'clear',
            child: Text('Clear filters'),
          ),
        ];
      },
      child: _filterButton(
        Icons.filter_list_rounded,
        'Filter',
        count: activeFilters.isEmpty ? null : activeFilters.length,
      ),
    );
  }

  Widget _sortMenu(BuildContext context) {
    return PopupMenuButton<CustomerSort>(
      color: AppColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tooltip: 'Sort',
      onSelected: onSortChanged,
      itemBuilder: (context) {
        return CustomerSort.values.map((sort) {
          return CheckedPopupMenuItem<CustomerSort>(
            value: sort,
            checked: sort == sortBy,
            child: Text(_sortLabel(sort)),
          );
        }).toList();
      },
      child: _filterButton(Icons.sort_rounded, 'Sort'),
    );
  }

  Widget _filterButton(IconData icon, String label, {int? count}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            count == null ? label : '$label ($count)',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
