import 'package:dream_pos/screens/dashboard/models/feature_model.dart';
import 'package:dream_pos/widgets/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeatureItemNotifier extends Notifier<List<FeatureItem>> {
  @override
  build() {
    return [
      FeatureItem(
        icon: Icons.point_of_sale_rounded,
        title: 'New Sales',
        subtitle: 'Create a new sales order',
        iconColor: AppColors.salesOrange,
        bgColor: AppColors.salesOrangeLight,
      ),
      FeatureItem(
        icon: Icons.add_shopping_cart_rounded,
        title: 'New Purchase',
        subtitle: 'Record new purchases',
        iconColor: AppColors.purchaseGreen,
        bgColor: AppColors.purchaseGreenLight,
      ),
      FeatureItem(
        icon: Icons.inventory_2_rounded,
        title: 'Products',
        subtitle: 'Manage your inventory',
        iconColor: AppColors.productsPurple,
        bgColor: AppColors.productsPurpleLight,
      ),
      FeatureItem(
        icon: Icons.analytics_rounded,
        title: 'Reports',
        subtitle: 'View sales and analytics',
        iconColor: AppColors.reportsPink,
        bgColor: AppColors.reportsPinkLight,
      ),
      FeatureItem(
        icon: Icons.people_alt_rounded,
        title: 'Customers',
        subtitle: 'Manage customer data',
        iconColor: AppColors.customersTeal,
        bgColor: AppColors.customersTealLight,
      ),
      FeatureItem(
        icon: Icons.receipt_long_rounded,
        title: 'Expenses',
        subtitle: 'Track business expenses',
        iconColor: AppColors.expensesRed,
        bgColor: AppColors.expensesRedLight,
      ),
    ];
  }
}

final featureItemProvider =
    NotifierProvider<FeatureItemNotifier, List<FeatureItem>>(
      FeatureItemNotifier.new,
    );
