import 'dart:io';
import 'dart:math';

import 'package:dream_pos/screens/expenses/controllers/add_expense_controller.dart';
import 'package:dream_pos/screens/products/model/product.dart';
import 'package:dream_pos/screens/products/widgets/product_section.dart';
import 'package:dream_pos/screens/products/widgets/product_text_field.dart';
import 'package:dream_pos/widgets/customButtons.dart';
import 'package:dream_pos/widgets/customSnackBar.dart';
import 'package:flutter/material.dart';

import '../../widgets/appColors.dart';
import '../../widgets/customDropDown.dart';
import '../../widgets/date_picker_bottom_sheet.dart';
import 'model/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key, this.expense});

  final Expense? expense;

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late AddExpenseController controller;

  @override
  void initState() {
    super.initState();
    controller = AddExpenseController();

    // ✏️ Edit Expense
    if (widget.expense != null) {
      final e = widget.expense!;

      controller.expenseNameController.text = e.name;
      controller.amountController.text = e.amount.toString();
      controller.descriptionController.text = e.description ?? '';

      controller.category = e.category;
      controller.status = e.status;
      controller.date = e.date;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void saveExpense() {
    // 🔒 Validation
    if (controller.expenseNameController.text.isEmpty ||
        controller.amountController.text.isEmpty ||
        controller.category == null) {
      showCustomSnackBar(
        context,
        description: 'Please fill all required fields',
      );
      return;
    }

    final amount = double.tryParse(controller.amountController.text);

    if (amount == null || amount <= 0) {
      showCustomSnackBar(context, description: 'Please enter a valid amount');
      return;
    }

    // ✏️ EDIT EXPENSE
    if (widget.expense != null) {
      final index = Expense.expensesList.indexWhere(
        (e) => e.id == widget.expense!.id,
      );

      if (index != -1) {
        Expense.expensesList[index] = Expense(
          id: widget.expense!.id,
          name: controller.expenseNameController.text.trim(),
          category: controller.category!,
          amount: amount,
          description: controller.descriptionController.text.isEmpty
              ? null
              : controller.descriptionController.text.trim(),
          date: controller.date,
          status: controller.status,
        );
      }
    }
    // ➕ ADD EXPENSE
    else {
      final id = (Random().nextInt(90000) + 10000).toString();
      Expense.expensesList.add(
        Expense(
          id: id,
          name: controller.expenseNameController.text.trim(),
          category: controller.category!,
          amount: amount,
          description: controller.descriptionController.text.isEmpty
              ? null
              : controller.descriptionController.text.trim(),
          date: controller.date,
          status: controller.status,
        ),
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// HEADER
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.expense == null
                          ? 'Create Expense'
                          : 'Update Expense',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Expense details',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ProductTopActions(
                  onRefresh: () {
                    setState(() {
                      controller.reset();
                    });
                  },
                  buttonLabel: 'Back to Expenses',
                  onBack: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 18),

            /// EXPENSE INFORMATION
            ProductSection(
              title: 'Expense Information',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ProductTextField(
                          label: 'Expense Name',
                          controller: controller.expenseNameController,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomDropdown(
                          label: 'Category',
                          hintText: 'Select Category',
                          value: controller.category,
                          options: const [
                            'Electronics',
                            'Computers',
                            'Audio',
                            'Accessories',
                            'Footwear',
                            'Tablets',
                            'Other',
                          ],
                          onChanged: (value) {
                            setState(() {
                              controller.category = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: ProductTextField(
                          label: 'Amount',
                          controller: controller.amountController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomDropdown(
                          label: 'Status',
                          hintText: 'Select Status',
                          value: controller.status,
                          options: const ['Paid', 'Pending'],
                          onChanged: (value) {
                            setState(() {
                              controller.status = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  ProductTextField(
                    isForDate: true,
                    keyboardType: TextInputType.datetime,
                    suffixIcon: Icons.calendar_month,
                    label: 'Date',
                    readOnly: true,
                    controller: TextEditingController(
                      text: controller.date.toIso8601String().split('T').first,
                    ),
                    onTap: () async {
                      final selectedDate = await showPosDatePicker(
                        context: context,
                        title: 'Select Expense Date',
                      );
                      if (selectedDate != null) {
                        setState(() {
                          controller.date = selectedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),

            /// DESCRIPTION
            ProductSection(
              title: 'Description',
              child: TextField(
                controller: controller.descriptionController,
                cursorColor: AppColors.primaryOrange,
                maxLines: 4,
                maxLength: 300,
                decoration: InputDecoration(
                  hintText: 'Enter description (optional)',
                  filled: true,
                  fillColor: const Color(0xFFF2F3F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ACTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomElevatedButton(
                  text: 'Cancel',
                  onPressed: () => Navigator.pop(context),
                  width: 110,
                  height: 40,
                  textSize: 14,
                  textColor: AppColors.white,
                  backgroundColor: Colors.black,
                ),
                const SizedBox(width: 12),
                CustomElevatedButton(
                  text: widget.expense == null
                      ? 'Add Expense'
                      : 'Update Expense',
                  onPressed: saveExpense,
                  width: widget.expense == null ? 135 : 155,
                  height: 40,
                  textSize: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
