import 'dart:io';

import 'package:dream_pos/screens/products/model/product.dart';
import 'package:dream_pos/screens/products/providers/product_provider.dart';
import 'package:dream_pos/screens/products/widgets/product_section.dart';
import 'package:dream_pos/screens/products/widgets/product_text_field.dart';
import 'package:dream_pos/widgets/customButtons.dart';
import 'package:dream_pos/widgets/customSnackBar.dart';
import 'package:dream_pos/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/appColors.dart';
import '../../widgets/customDropDown.dart';
import '../../widgets/date_picker_bottom_sheet.dart';
import 'controllers/add_product_controller.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key, this.product});

  final Product? product;

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  late AddProductController controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = AddProductController();

    if (widget.product != null) {
      final p = widget.product!;

      controller.productName.text = p.name;
      controller.slug.text = p.slug;
      controller.sku.text = p.sku;
      controller.subCategory.text = p.subCategory;

      controller.quantity.text = p.quantity.toString();
      controller.price.text = p.price.toString();
      controller.salePrice.text = p.salePrice.toString();
      controller.quantityAlert.text = p.quantityAlert.toString();

      controller.description.text = p.description ?? '';

      controller.sellingTypeId = p.sellingType;
      controller.categoryId = p.category;
      controller.brandId = p.brand;
      controller.unitId = p.unit;

      controller.hasWarranty = p.hasWarranty;
      controller.expiryDate = p.expiryDate;

      controller.images.addAll(p.images);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Validate form fields
  bool _validate() {
    if (controller.productName.text.isEmpty ||
        controller.slug.text.isEmpty ||
        controller.sku.text.isEmpty ||
        controller.subCategory.text.isEmpty ||
        controller.quantity.text.isEmpty ||
        controller.price.text.isEmpty ||
        controller.quantityAlert.text.isEmpty ||
        controller.sellingTypeId == null ||
        controller.categoryId == null ||
        controller.brandId == null ||
        controller.unitId == null) {
      CustomSnackBar.show(context, message: 'Please fill all the fields');
      return false;
    }
    return true;
  }

  /// Build product from form data
  Product _buildProduct() {
    return Product(
      id: widget.product?.id ?? '',
      name: controller.productName.text,
      description: controller.description.text,
      slug: controller.slug.text,
      sku: controller.sku.text,
      sellingType: controller.sellingTypeId!,
      category: controller.categoryId!,
      subCategory: controller.subCategory.text,
      brand: controller.brandId!,
      unit: controller.unitId!,
      quantity: int.parse(controller.quantity.text),
      price: double.parse(controller.price.text),
      salePrice: double.tryParse(controller.salePrice.text) ?? 0,
      quantityAlert: int.parse(controller.quantityAlert.text),
      expiryDate: controller.expiryDate,
      hasWarranty: controller.hasWarranty,
      images: List.from(controller.images),
    );
  }

  /// Save product - delegates to provider
  Future<void> saveProduct() async {
    if (!_validate()) return;

    setState(() => _isLoading = true);

    try {
      final productNotifier = ref.read(productProvider.notifier);
      final product = _buildProduct();

      if (widget.product != null) {
        // ✏️ UPDATE PRODUCT
        await productNotifier.updateProduct(product);
        if (mounted) {
          CustomSnackBar.show(
            context,
            message: 'Product updated successfully!',
          );
        }
      } else {
        // ➕ CREATE PRODUCT
        await productNotifier.createProduct(product);
        if (mounted) {
          CustomSnackBar.show(
            context,
            message: 'Product created successfully!',
          );
        }
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.show(context, message: e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product == null
                          ? 'Create Product'
                          : 'Update Product',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Product Details',
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
                  onBack: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 18),

            /// PRODUCT INFORMATION
            ProductSection(
              title: 'Product Information',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ProductTextField(
                          label: 'Product Name  ',
                          controller: controller.productName,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ProductTextField(
                          label: 'Slug  ',
                          controller: controller.slug,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: ProductTextField(
                          label: 'SKU  ',
                          controller: controller.sku,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomDropdown(
                          label: 'Selling Type',
                          hintText: 'Select Selling Type',
                          value: controller.sellingTypeId,
                          options: const ['Online', 'POS'],
                          onChanged: (value) {
                            setState(() {
                              controller.sellingTypeId = value;
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
                        child: CustomDropdown(
                          label: 'Category',
                          hintText: 'Select Category',
                          value: controller.categoryId,
                          options: const ['Electronics', 'Clothing', 'Grocery'],
                          onChanged: (value) {
                            setState(() {
                              controller.categoryId = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ProductTextField(
                          label: 'Sub Category  ',
                          controller: controller.subCategory,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdown(
                          label: 'Brand',
                          hintText: 'Select Brand',
                          value: controller.brandId,
                          options: const ['Apple', 'Samsung', 'Sony'],
                          onChanged: (value) {
                            setState(() {
                              controller.brandId = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomDropdown(
                          label: 'Unit',
                          hintText: 'Select Unit',
                          value: controller.unitId,
                          options: const ['Pcs', 'Kg', 'Ltr', 'Bx', 'dz'],
                          onChanged: (value) {
                            setState(() {
                              controller.unitId = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// PRICING & STOCK
            ProductSection(
              title: 'Pricing & Stocks',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ProductTextField(
                          label: 'Quantity  ',
                          controller: controller.quantity,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ProductTextField(
                          label: 'Price  ',
                          controller: controller.price,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ProductTextField(
                          label: 'Sale Price  ',
                          controller: controller.salePrice,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ProductTextField(
                          label: 'Quantity Alert  ',
                          controller: controller.quantityAlert,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// DESCRIPTION
            ProductSection(
              title: 'Description',
              child: TextField(
                controller: controller.description,
                cursorColor: AppColors.primaryOrange,
                maxLines: 4,
                maxLength: 300,
                decoration: InputDecoration(
                  hintText: 'Enter Description here...',
                  filled: true,
                  fillColor: const Color(0xFFF2F3F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            /// images
            ProductSection(
              title: 'Images',
              child: SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.images.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    /// ADD IMAGE TILE
                    if (index == controller.images.length) {
                      return InkWell(
                        onTap: () async {
                          final added = await controller.pickImage(context);
                          if (added) {
                            setState(() {});
                          }
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 120,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add, color: Colors.grey),
                              SizedBox(height: 6),
                              Text(
                                'Add Images',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    /// IMAGE TILE
                    return Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: FileImage(File(controller.images[index])),
                              // image: FileImage(controller.images[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        /// REMOVE BUTTON
                        Positioned(
                          top: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                controller.removeImage(index);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            /// Custom Field
            ProductSection(
              title: 'Custom Fields',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdown(
                          label: 'Warranty',
                          hintText: 'Select Warranty',
                          value: controller.hasWarranty ? 'Yes' : 'No',
                          options: const ['Yes', 'No'],
                          onChanged: (value) {
                            setState(() {
                              controller.hasWarranty = value == 'Yes';
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ProductTextField(
                          suffixIcon: Icons.calendar_month,
                          onTap: () async {
                            final date = await showPosDatePicker(
                              context: context,
                              title: 'Select Expiry Date',
                            );

                            if (date != null) {
                              setState(() {
                                controller.expiryDate = date;
                              });
                            }
                          },
                          label: 'Expiry Date',
                          keyboardType: TextInputType.text,
                          controller: TextEditingController(
                            text: controller.expiryDate == null
                                ? ''
                                : controller.expiryDate!
                                      .toIso8601String()
                                      .split('T')
                                      .first,
                          ),
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// ACTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomElevatedButton(
                  text: 'Cancel',
                  onPressed: _isLoading
                      ? () {}
                      : () => Navigator.of(context).pop(),
                  width: 110,
                  height: 40,
                  textSize: 14,
                  textColor: AppColors.white,
                  backgroundColor: Colors.black,
                ),
                const SizedBox(width: 12),
                _isLoading
                    ? const SizedBox(
                        width: 135,
                        height: 40,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : CustomElevatedButton(
                        text: widget.product == null
                            ? 'Add Product'
                            : 'Update Product',
                        onPressed: saveProduct,
                        width: widget.product == null ? 135 : 155,
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
