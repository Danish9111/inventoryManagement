import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Assuming these exist based on your imports
import '../../widgets/appColors.dart';
import 'providers/customer_provider.dart';
import 'widgets/customer_header.dart';
import 'widgets/customer_filters.dart';
import 'widgets/customer_table_header.dart';
import 'widgets/customer_list_tile.dart';
import 'customers_responsive_helper.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen>
    with SingleTickerProviderStateMixin {
  // State
  String _searchQuery = '';
  Set<CustomerFilter> _activeFilters = {};
  CustomerSort _sortBy = CustomerSort.nameAsc;
  Timer? _debounce;
  final ScrollController _scrollController = ScrollController();

  // Animations
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuart, // Smoother entry curve
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = query;
      });
    });
  }

  void _resetSearch() {
    setState(() {
      _searchQuery = '';
      // logic to clear text field controller if you were managing it directly
    });
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customerProvider);

    final filteredCustomers = customers.where((customer) {
      final query = _searchQuery.toLowerCase();
      final matchesSearch =
          customer.name.toLowerCase().contains(query) ||
          customer.email.toLowerCase().contains(query) ||
          customer.phone.toLowerCase().contains(query);
      if (!matchesSearch) return false;

      if (_activeFilters.contains(CustomerFilter.highSpender) &&
          customer.totalSpent < 1000) {
        return false;
      }
      if (_activeFilters.contains(CustomerFilter.highLoyalty) &&
          customer.loyaltyPoints < 100) {
        return false;
      }
      if (_activeFilters.contains(CustomerFilter.newCustomer)) {
        final isNew = customer.createdAt.isAfter(
          DateTime.now().subtract(const Duration(days: 30)),
        );
        if (!isNew) return false;
      }

      return true;
    }).toList();

    filteredCustomers.sort((a, b) {
      switch (_sortBy) {
        case CustomerSort.nameAsc:
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        case CustomerSort.nameDesc:
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        case CustomerSort.totalSpentDesc:
          return b.totalSpent.compareTo(a.totalSpent);
        case CustomerSort.totalSpentAsc:
          return a.totalSpent.compareTo(b.totalSpent);
        case CustomerSort.newest:
          return b.createdAt.compareTo(a.createdAt);
        case CustomerSort.oldest:
          return a.createdAt.compareTo(b.createdAt);
      }
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final r = CustomersResponsiveHelper(constraints.maxWidth);

        return Scaffold(
          backgroundColor: AppColors.backgroundGrey,
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: EdgeInsets.all(r.pagePadding),
              child: Column(
                children: [
                  // 🏷 HEADER SECTION
                  CustomerHeader(
                    onAddCustomer: () => debugPrint('Add Dialog'),
                    onRefresh: () {
                      _animationController.reset();
                      _animationController.forward();
                      // Add actual data refresh logic here
                    },
                  ),

                  SizedBox(height: r.sectionSpacing),

                  CustomerFilters(
                    onSearch: _onSearchChanged,
                    activeFilters: _activeFilters,
                    onFiltersChanged: (filters) {
                      setState(() {
                        _activeFilters = filters;
                      });
                    },
                    sortBy: _sortBy,
                    onSortChanged: (sort) {
                      setState(() {
                        _sortBy = sort;
                      });
                    },
                  ),

                  // SizedBox(height: r.sectionSpacing),
                  SizedBox(height: r.sectionSpacing),

                  // 📋 MAIN CONTENT CARD
                  Expanded(
                    child: Container(
                      clipBehavior: Clip
                          .antiAlias, // Ensures rounded corners clip children
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          16,
                        ), // Softer corners
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF101828,
                            ).withOpacity(0.06), // Modern subtle shadow
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Fixed Table Header
                          CustomerTableHeader(),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     border: Border(
                          //       bottom: BorderSide(color: Colors.grey.shade100),
                          //     ),
                          //     color: Colors
                          //         .grey
                          //         .shade50, // Slight contrast for header
                          //   ),
                          //   padding: const EdgeInsets.symmetric(vertical: 12),
                          //   child: const
                          // ),

                          // Scrollable List
                          Expanded(
                            child: filteredCustomers.isEmpty
                                ? _buildEmptyState()
                                : ListView.separated(
                                    controller: _scrollController,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: filteredCustomers.length,
                                    separatorBuilder: (c, i) => Divider(
                                      height: 1,
                                      color: Colors.grey.shade100,
                                    ),
                                    itemBuilder: (context, index) {
                                      final customer = filteredCustomers[index];
                                      return CustomerListTile(
                                        customer: customer,
                                        onEdit: () {},
                                        onDelete: () {
                                          ref
                                              .read(customerProvider.notifier)
                                              .deleteCustomer(customer.id);
                                        },
                                      );
                                    },
                                  ),
                          ),

                          // 🦶 Footer / Pagination could go here
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        // Prevents overflow on small screens
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 48,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty
                  ? 'No customers yet'
                  : 'No results for "$_searchQuery"',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(color: Colors.grey.shade500),
            ),
            const SizedBox(height: 24),
            // ⚡️ UX IMPROVEMENT: Action Button in Empty State
            if (_searchQuery.isNotEmpty)
              OutlinedButton.icon(
                onPressed: _resetSearch,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Reset Search'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
