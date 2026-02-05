import 'package:dream_pos/constants/appColors.dart';
import 'package:flutter/material.dart';

class Filters extends StatelessWidget {
  final List<String> categories;
  final List<String> brands;

  final String? selectedCategory;
  final String? selectedBrand;

  final ValueChanged<String> onSearch;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onBrandChanged;

  const Filters({
    super.key,
    required this.categories,
    required this.brands,
    required this.onSearch,
    required this.onCategoryChanged,
    required this.onBrandChanged,
    this.selectedCategory,
    this.selectedBrand,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: TextField(
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const Spacer(),
        _dropdown(
          hint: 'Category',
          value: selectedCategory,
          items: categories,
          onChanged: onCategoryChanged,
        ),
        const SizedBox(width: 8),
        _dropdown(
          hint: 'Brand',
          value: selectedBrand,
          items: brands,
          onChanged: onBrandChanged,
        ),
      ],
    );
  }

  Widget _dropdown({
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: AppColors.white,
          hint: Text(hint),
          value: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
