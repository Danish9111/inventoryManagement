import 'package:dream_pos/screens/pos/pos_responsive_helper.dart';
import 'package:dream_pos/widgets/appColors.dart';
import 'package:flutter/material.dart';

/// Category Filter Pills Widget
class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final bool showFeaturedOnly;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<bool> onFeaturedToggle;
  final PosResponsiveHelper responsive;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.showFeaturedOnly,
    required this.onCategorySelected,
    required this.onFeaturedToggle,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    final r = responsive;

    return SizedBox(
      height: r.filterButtonHeight,
      child: Row(
        children: [
          // View All Brands Button
          // _buildFilterButton(
          //   label: 'View All Brands',
          //   icon: Icons.layers_outlined,
          //   isSelected: selectedCategory == 'All' && !showFeaturedOnly,
          //   onTap: () {
          //     onCategorySelected('All');
          //     onFeaturedToggle(false);
          //   },
          //   r: r,
          //   isPrimary: true,
          // ),

          // SizedBox(width: r.scale(8, 12)),

          // // Featured Button
          // _buildFilterButton(
          //   label: 'Featured',
          //   icon: Icons.star_rounded,
          //   isSelected: showFeaturedOnly,
          //   onTap: () => onFeaturedToggle(!showFeaturedOnly),
          //   r: r,
          //   isPrimary: false,
          //   isAccent: true,
          // ),

          // SizedBox(width: r.scale(12, 16)),

          // Category Pills
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => SizedBox(width: r.scale(6, 10)),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected =
                    category == selectedCategory && !showFeaturedOnly;
                return _buildCategoryPill(category, isSelected, r);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPill(
    String category,
    bool isSelected,
    PosResponsiveHelper r,
  ) {
    return InkWell(
      onTap: () => onCategorySelected(category),
      borderRadius: BorderRadius.circular(r.scale(8, 10)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: r.scale(14, 20)),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBlue.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(r.scale(8, 10)),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              fontSize: r.filterFontSize,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.primaryBlue : AppColors.textGrey,
            ),
          ),
        ),
      ),
    );
  }
}
