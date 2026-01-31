import 'package:flutter/material.dart';

import 'appColors.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final String hintText;
  final List<String> options;
  final String? value;
  final ValueChanged<String> onChanged;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.onChanged,
    this.value,
    this.hintText = 'Select',
  });

  void _openBottomSheet(BuildContext context) {
    final media = MediaQuery.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      constraints: const BoxConstraints(
        maxWidth: double.infinity, // 🔥 THIS IS THE KEY
      ),
      builder: (_) {
        return Container(
          width: media.size.width,
          height: media.size.height * 0.6, // 🔥 fixed half height
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Text(
                      'Select $label',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Scrollable List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: options.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade200),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = option == value;

                    return ListTile(
                      title: Text(option, style: const TextStyle(fontSize: 15)),
                      trailing: AnimatedOpacity(
                        opacity: isSelected ? 1 : 0,
                        duration: const Duration(milliseconds: 150),
                        child: Icon(
                          Icons.check_circle,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                      onTap: () {
                        onChanged(option);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _openBottomSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F3F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hasValue ? value! : hintText,
                    style: TextStyle(
                      color: hasValue ? Colors.black : Colors.grey,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Usage Example
// CustomDropdown(
// label: 'Category *',
// hintText: 'Select Category',
// value: controller.categoryId,
// options: const ['Electronics', 'Clothing', 'Grocery'],
// onChanged: (value) {
// setState(() {
// controller.categoryId = value;
// });
// },
// ),
