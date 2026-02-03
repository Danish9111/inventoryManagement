import 'package:dream_pos/screens/pos/cart_provider.dart';
import 'package:dream_pos/screens/pos/pos_responsive_helper.dart';
import 'package:dream_pos/screens/pos/widgets/cart_item_tile.dart';
import 'package:dream_pos/widgets/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PosCartPanel extends ConsumerWidget {
  final PosResponsiveHelper responsive;
  final VoidCallback onDiscountTap;
  final VoidCallback onPaymentTap;

  const PosCartPanel({
    super.key,
    required this.responsive,
    required this.onDiscountTap,
    required this.onPaymentTap,
  });

  // Mock customers list - in real app this comes from CustomerProvider
  static final List<Map<String, dynamic>> _customers = [
    {'name': 'Walk in Customer', 'bonus': 0, 'loyalty': 0},
    {'name': 'James Anderson', 'bonus': 148, 'loyalty': 20},
    {'name': 'Sarah Johnson', 'bonus': 75, 'loyalty': 15},
    {'name': 'Mike Williams', 'bonus': 200, 'loyalty': 50},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch cart state
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    final cartItems = cartState.cartItems;
    final r = responsive;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: Column(
        children: [
          // 📜 SCROLLABLE CONTENT - Everything including header scrolls now
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Header (Scrolls away now)
                SliverToBoxAdapter(
                  child: _buildCartHeader(
                    r,
                    cartItems.isNotEmpty,
                    cartNotifier.clearCart,
                  ),
                ),

                // Customer Management Section
                SliverToBoxAdapter(
                  child: _buildCustomerSection(
                    context,

                    r,
                    cartState.selectedCustomer,
                    cartNotifier.setCustomer,
                  ),
                ),

                // Order Details Header (Column Titles)
                SliverToBoxAdapter(child: _buildOrderDetailsHeader(r)),

                // Cart Items List
                cartItems.isEmpty
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: _buildEmptyCart(r),
                      )
                    : SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: r.scale(10, 14),
                          vertical: r.scale(6, 10),
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final item = cartItems[index];
                            return CartItemTile(
                              cartItem: item,
                              onIncrement: () =>
                                  cartNotifier.increment(item.product.id),
                              onDecrement: () =>
                                  cartNotifier.decrement(item.product.id),
                              onRemove: () =>
                                  cartNotifier.remove(item.product.id),
                              responsive: r,
                            );
                          }, childCount: cartItems.length),
                        ),
                      ),
              ],
            ),
          ),

          // 🔒 FIXED FOOTER - Order Summary & Pay Button
          if (cartItems.isNotEmpty) _buildOrderSummaryCompact(context, r, ref),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(PosResponsiveHelper r) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: r.scale(48, 64),
            color: AppColors.textGrey.withOpacity(0.3),
          ),
          SizedBox(height: r.scale(12, 16)),
          Text(
            'No items in cart',
            style: TextStyle(
              fontSize: r.scale(14, 16),
              fontWeight: FontWeight.w500,
              color: AppColors.textGrey,
            ),
          ),
          SizedBox(height: r.scale(4, 8)),
          Text(
            'Tap on products to add them',
            style: TextStyle(
              fontSize: r.scale(11, 13),
              color: AppColors.textGrey.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartHeader(
    PosResponsiveHelper r,
    bool hasItems,
    VoidCallback onClear,
  ) {
    final orderId =
        '#ORD${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.scale(12, 18),
        vertical: r.scale(10, 14),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Order List',
            style: TextStyle(
              fontSize: r.scale(15, 18),
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          Row(
            children: [
              // Order ID Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: r.scale(8, 10),
                  vertical: r.scale(3, 5),
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  orderId,
                  style: TextStyle(
                    fontSize: r.scale(9, 11),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: r.scale(6, 8)),
              // Delete All Button
              InkWell(
                onTap: hasItems ? onClear : null,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: EdgeInsets.all(r.scale(5, 7)),
                  decoration: BoxDecoration(
                    color: hasItems
                        ? AppColors.expensesRed
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    size: r.scale(14, 18),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSection(
    BuildContext context,
    PosResponsiveHelper r,
    String selectedCustomer,
    Function(String) onCustomerChanged,
  ) {
    // Ensure selectedCustomer is in list, otherwise default to first
    String effectiveSelection = selectedCustomer.isEmpty
        ? _customers.first['name']
        : selectedCustomer;
    if (!_customers.any((c) => c['name'] == effectiveSelection)) {
      effectiveSelection = _customers.first['name'];
    }

    return Container(
      padding: EdgeInsets.all(r.scale(10, 14)),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Information',
            style: TextStyle(
              fontSize: r.scale(12, 14),
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: r.scale(8, 12)),

          // Customer Dropdown Row
          Row(
            children: [
              // Dropdown
              Expanded(
                child: Container(
                  height: r.scale(36, 42),
                  padding: EdgeInsets.symmetric(horizontal: r.scale(10, 14)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(r.scale(8, 10)),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: AppColors.white,
                      value: effectiveSelection,
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: r.scale(18, 22),
                        color: AppColors.textGrey,
                      ),
                      style: TextStyle(
                        fontSize: r.scale(11, 13),
                        color: AppColors.textDark,
                      ),
                      items: _customers.map((c) {
                        return DropdownMenuItem<String>(
                          value: c['name'] as String,
                          child: Text(c['name'] as String),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          onCustomerChanged(value);
                        }
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(width: r.scale(8, 10)),

              // Add Customer Button
              _buildIconButton(
                icon: Icons.person_add_outlined,
                color: AppColors.primaryBlue,
                onTap: () {
                  _showAddCustomerDialog(context);
                },
                r: r,
              ),
              SizedBox(width: r.scale(6, 8)),

              // Refresh Button
              _buildIconButton(
                icon: Icons.swap_horiz_rounded,
                color: AppColors.primaryBlue,
                onTap: () {
                  onCustomerChanged('Walk in Customer');
                },
                r: r,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddCustomerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Customer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Name')),
            TextField(decoration: const InputDecoration(labelText: 'Email')),
            TextField(decoration: const InputDecoration(labelText: 'Phone')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required PosResponsiveHelper r,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(r.scale(8, 10)),
      child: Container(
        padding: EdgeInsets.all(r.scale(8, 10)),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(r.scale(8, 10)),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Icon(icon, color: color, size: r.scale(18, 22)),
      ),
    );
  }

  Widget _buildOrderDetailsHeader(PosResponsiveHelper r) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: r.scale(12, 16),
        vertical: r.scale(8, 10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'Item',
              style: TextStyle(
                fontSize: r.scale(11, 13),
                fontWeight: FontWeight.w600,
                color: AppColors.textGrey,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Qty',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: r.scale(11, 13),
                fontWeight: FontWeight.w600,
                color: AppColors.textGrey,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Total',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: r.scale(11, 13),
                fontWeight: FontWeight.w600,
                color: AppColors.textGrey,
              ),
            ),
          ),
          SizedBox(width: r.scale(20, 24)), // Space for delete icon
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCompact(
    BuildContext context,
    PosResponsiveHelper r,
    WidgetRef ref,
  ) {
    final cartState = ref.watch(cartProvider);

    final subTotal = cartState.subtotal;
    // Assuming fix tax for now or get from provider if available
    final taxRate = 5.0;
    final discountAmount = cartState.discountAmount;
    final tax = subTotal * taxRate / 100;
    final total = subTotal + tax - discountAmount;

    return Container(
      padding: EdgeInsets.all(r.scale(12, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Subtotal
          _buildSummaryRow(r, 'Subtotal', subTotal),
          SizedBox(height: r.scale(4, 6)),

          // Discount
          InkWell(
            onTap: onDiscountTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Discount',
                      style: TextStyle(
                        fontSize: r.scale(12, 14),
                        color: AppColors.textGrey,
                      ),
                    ),
                    SizedBox(width: r.scale(4, 6)),
                    Icon(
                      Icons.edit_outlined,
                      size: r.scale(12, 14),
                      color: AppColors.primaryBlue,
                    ),
                  ],
                ),
                Text(
                  '-\$${discountAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: r.scale(12, 14),
                    fontWeight: FontWeight.w600,
                    color: AppColors.purchaseGreen,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: r.scale(4, 6)),

          // Tax
          _buildSummaryRow(r, 'Tax ($taxRate%)', tax),

          const Divider(height: 16),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: r.scale(16, 18),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: r.scale(18, 20),
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: r.scale(12, 16)),

          // Pay Button
          SizedBox(
            width: double.infinity,
            height: r.scale(42, 48),
            child: ElevatedButton(
              onPressed: onPaymentTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(r.scale(8, 10)),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payment,
                    color: Colors.white,
                    size: r.scale(18, 22),
                  ),
                  SizedBox(width: r.scale(8, 10)),
                  Text(
                    'Proceed to Payment',
                    style: TextStyle(
                      fontSize: r.scale(14, 16),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(PosResponsiveHelper r, String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: r.scale(12, 14),
            color: AppColors.textGrey,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: r.scale(12, 14),
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
