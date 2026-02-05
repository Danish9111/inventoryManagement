// import 'package:flutter/material.dart';
// import '../model/product.dart';
//
// class AddProductController {
//   // Product Info
//   final TextEditingController productName = TextEditingController();
//   final TextEditingController slug = TextEditingController();
//   final TextEditingController sku = TextEditingController();
//
//   // Pricing & Stock
//   final TextEditingController price = TextEditingController();
//   final TextEditingController quantity = TextEditingController();
//   final TextEditingController quantityAlert = TextEditingController();
//   final TextEditingController discountValue = TextEditingController();
//
//   // Barcode / QR
//   final TextEditingController itemBarcode = TextEditingController();
//
//   // Description
//   final TextEditingController description = TextEditingController();
//
//   // Custom Fields
//   final TextEditingController manufacturer = TextEditingController();
//
//   // Dropdown / Selection Values
//   String? storeId;
//   String? warehouseId;
//   String? categoryId;
//   String? subCategoryId;
//   String? brandId;
//   String? unitId;
//   String? sellingTypeId;
//   String? taxId;
//   String? barcodeSymbology;
//
//   // Custom Fields Toggles
//   bool enableWarranty = false;
//   bool enableManufacturer = false;
//   bool enableExpiry = false;
//
//   DateTime? manufacturedDate;
//   DateTime? expiryDate;
//
//   // Images
//   final List<String> images = [];
//
//   void dispose() {
//     productName.dispose();
//     slug.dispose();
//     sku.dispose();
//     price.dispose();
//     quantity.dispose();
//     quantityAlert.dispose();
//     discountValue.dispose();
//     itemBarcode.dispose();
//     description.dispose();
//     manufacturer.dispose();
//   }
// }
import 'dart:io';

import 'package:dream_pos/constants/appColors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddProductController {
  // Product Info
  final productName = TextEditingController();
  final slug = TextEditingController();
  final sku = TextEditingController();
  final subCategory = TextEditingController();

  // Pricing & Stock
  final quantity = TextEditingController();
  final price = TextEditingController();
  final salePrice = TextEditingController();
  final quantityAlert = TextEditingController();

  // Description
  final description = TextEditingController();

  // Dropdown values
  String? sellingTypeId;
  String? categoryId;
  String? brandId;
  String? unitId;

  // Custom Fields
  bool hasWarranty = false; // ✅ boolean
  DateTime? expiryDate;

  final ImagePicker _picker = ImagePicker();
  final List<String> images = [];

  Future<bool> pickImage(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      constraints: const BoxConstraints(
        maxWidth: double.infinity, // 🔥 REQUIRED FOR DESKTOP WIDTH
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: SizedBox(
            height: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 16),
                _buildPickerTile(
                  icon: Icons.camera_alt,
                  title: 'Camera',
                  onTap: () async {
                    Navigator.pop(context);
                    final added = await _pickFromSource(ImageSource.camera);
                    Navigator.of(context).pop(added);
                  },
                ),
                _buildPickerTile(
                  icon: Icons.photo_library,
                  title: 'Gallery',
                  onTap: () async {
                    Navigator.pop(context);
                    final added = await _pickFromSource(ImageSource.gallery);
                    Navigator.of(context).pop(added);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    return true;
  }

  Future<bool> _pickFromSource(ImageSource source) async {
    PermissionStatus permission;

    if (Platform.isIOS) {
      permission = source == ImageSource.camera
          ? await Permission.camera.request()
          : await Permission.photos.request();
    } else {
      permission = source == ImageSource.camera
          ? await Permission.camera.request()
          : await Permission.storage.request();
    }

    if (!permission.isGranted) return false;

    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      images.add(image.path); // String
      return true;
    }
    return false;
  }

  Widget _buildPickerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 22, color: AppColors.primaryOrange),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }

  void removeImage(int index) {
    images.removeAt(index);
  }

  void reset() {
    productName.clear();
    slug.clear();
    sku.clear();
    subCategory.clear();

    quantity.clear();
    price.clear();
    salePrice.clear();
    quantityAlert.clear();

    description.clear();

    sellingTypeId = null;
    categoryId = null;
    brandId = null;
    unitId = null;

    hasWarranty = false;
    expiryDate = null;

    images.clear();
  }

  void dispose() {
    productName.dispose();
    slug.dispose();
    sku.dispose();
    subCategory.dispose();
    quantity.dispose();
    price.dispose();
    salePrice.dispose();
    quantityAlert.dispose();
    description.dispose();
  }
}
