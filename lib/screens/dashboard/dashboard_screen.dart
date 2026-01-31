import 'package:dream_pos/screens/dashBoard/models/feature_model.dart';
import 'package:dream_pos/screens/dashBoard/responsive_helper.dart';
import 'package:dream_pos/screens/dashBoard/widgets/feature_card.dart';
import 'package:dream_pos/screens/dashBoard/widgets/summary_card.dart';
import 'package:flutter/material.dart';
import '../../widgets/appColors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundGrey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;

          // Create responsive helper with fluid scaling
          final responsive = ResponsiveHelper(screenWidth);

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.horizontalPadding,
              vertical: responsive.verticalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header - Responsive
                _buildHeader(responsive),
                SizedBox(height: responsive.sectionSpacing),

                // 🔹 FEATURE CARDS SECTION
                _buildFeatureCardsSection(context, responsive),

                SizedBox(height: responsive.sectionSpacing * 1.3),

                // 🔹 SUMMARY SECTION
                _buildSummarySection(context, responsive),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 🔸 RESPONSIVE HEADER
  Widget _buildHeader(ResponsiveHelper responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard',
          style: TextStyle(
            fontSize: responsive.headerTitleSize,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: responsive.scale(4, 8)),
        Text(
          'Welcome back! Here\'s what\'s happening today.',
          style: TextStyle(
            fontSize: responsive.headerSubtitleSize,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  /// 🔸 FEATURE CARDS SECTION - Fully Responsive with Fluid Scaling
  Widget _buildFeatureCardsSection(
    BuildContext context,
    ResponsiveHelper responsive,
  ) {
    final features = [
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

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: responsive.featureGridColumns,
        crossAxisSpacing: responsive.gridSpacing,
        mainAxisSpacing: responsive.gridSpacing,
        childAspectRatio: responsive.featureCardAspectRatio,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return FeatureCard(feature: features[index], responsive: responsive);
      },
    );
  }

  /// 🔸 SUMMARY SECTION - Responsive
  Widget _buildSummarySection(
    BuildContext context,
    ResponsiveHelper responsive,
  ) {
    final summaryCards = [
      SummaryCard(
        icon: Icons.attach_money_rounded,
        title: 'Today\'s Sales',
        value: '\$4,285.00',
        change: '+12.5% from yesterday',
        isPositive: true,
        iconBgColor: AppColors.summaryGreenBg,
        iconColor: AppColors.summaryGreenText,
        responsive: responsive,
      ),
      SummaryCard(
        icon: Icons.trending_up_rounded,
        title: 'Today\'s Profit',
        value: '\$1,428.00',
        change: '+8.2% from yesterday',
        isPositive: true,
        iconBgColor: AppColors.summaryPurpleBg,
        iconColor: AppColors.summaryPurpleText,
        responsive: responsive,
      ),
      SummaryCard(
        icon: Icons.warning_amber_rounded,
        title: 'Low Stock Alerts',
        value: '8 Items',
        change: 'View stock details →',
        isPositive: false,
        isAlert: true,
        iconBgColor: AppColors.summaryOrangeBg,
        iconColor: AppColors.summaryOrangeText,
        responsive: responsive,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Summary',
          style: TextStyle(
            fontSize: responsive.summaryTitleSize,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: responsive.cardSpacing),
        // Responsive layout for summary cards
        if (responsive.useSummaryRow)
          Row(
            children: summaryCards
                .expand(
                  (card) => [
                    Expanded(child: card),
                    if (card != summaryCards.last)
                      SizedBox(width: responsive.cardSpacing),
                  ],
                )
                .toList(),
          )
        else
          Column(
            children: summaryCards
                .expand(
                  (card) => [
                    card,
                    if (card != summaryCards.last)
                      SizedBox(height: responsive.cardSpacing),
                  ],
                )
                .toList(),
          ),
      ],
    );
  }
}
