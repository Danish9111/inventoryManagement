import 'package:dream_pos/screens/dashboard/models/feature_model.dart';
import 'package:dream_pos/screens/dashboard/responsive_helper.dart';
import 'package:dream_pos/screens/dashboard/widgets/summary_card.dart';
import 'package:dream_pos/screens/dashboard/widgets/feature_card.dart';
import 'package:dream_pos/screens/dashboard/providers/feature_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/appColors.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final featuresItem = ref.watch(featureItemProvider);
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
                HeaderSection(responsive: responsive),
                SizedBox(height: responsive.sectionSpacing),

                FeaturedCardSection(
                  featuresItem: featuresItem,
                  responsive: responsive,
                ),

                SizedBox(height: responsive.sectionSpacing * 1.3),

                SummarySection(responsive: responsive),
              ],
            ),
          );
        },
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final ResponsiveHelper responsive;
  const HeaderSection({super.key, required this.responsive});
  @override
  Widget build(BuildContext context) {
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
}

class SummarySection extends StatelessWidget {
  final ResponsiveHelper responsive;

  const SummarySection({super.key, required this.responsive});
  @override
  Widget build(BuildContext context) {
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

class FeaturedCardSection extends ConsumerWidget {
  final ResponsiveHelper responsive;
  final List<FeatureItem> featuresItem;
  const FeaturedCardSection({
    super.key,
    required this.responsive,
    required this.featuresItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: responsive.featureGridColumns,
        crossAxisSpacing: responsive.gridSpacing,
        mainAxisSpacing: responsive.gridSpacing,
        childAspectRatio: responsive.featureCardAspectRatio,
      ),
      itemCount: featuresItem.length,
      itemBuilder: (context, index) {
        return FeatureCard(
          feature: featuresItem[index],
          responsive: responsive,
        );
      },
    );
  }
}
