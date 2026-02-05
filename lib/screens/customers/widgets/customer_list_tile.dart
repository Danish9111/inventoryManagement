import 'package:flutter/material.dart';
import '../models/customer_model.dart';
import '../../../constants/appColors.dart';

class CustomerListTile extends StatelessWidget {
  final Customer customer;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CustomerListTile({
    super.key,
    required this.customer,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          // 👤 AVATAR
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.customersTealLight,
            backgroundImage: customer.imageUrl != null
                ? AssetImage(customer.imageUrl!)
                : null,
            child: customer.imageUrl == null
                ? Text(
                    customer.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.customersTeal,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),

          // 📝 INFO
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  customer.email,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),

          // 📞 PHONE
          Expanded(
            flex: 2,
            child: Text(
              customer.phone,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
          ),

          // 💎 LOYALTY
          Expanded(
            flex: 2,
            child: Row(
              children: [
                const Icon(Icons.stars_rounded, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '${customer.loyaltyPoints} pts',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // 💰 SPENT
          Expanded(
            flex: 2,
            child: Text(
              '\$${customer.totalSpent.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.primaryBlue,
              ),
            ),
          ),

          // ⚙️ ACTIONS
          Row(
            children: [
              _actionIcon(Icons.edit_outlined, AppColors.primaryOrange, onEdit),
              const SizedBox(width: 8),
              _actionIcon(
                Icons.delete_outline_rounded,
                Colors.red.shade400,
                onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
