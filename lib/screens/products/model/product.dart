import 'dart:io';

import 'package:dream_pos/screens/products/data/productsData.dart';

class Product {
  // 🔑 Identification
  final String id;
  final String name;
  final String slug;
  final String sku;

  // 🗂 Classification
  final String sellingType; // Online / POS
  final String category;
  final String subCategory;
  final String brand;
  final String unit;

  // 💰 Pricing & Stock
  final int quantity;
  final double price;
  final double? salePrice;
  final int quantityAlert;

  // 📝 Description
  final String? description;

  // 🖼 Images
  final List<String> images; // local paths or URLs

  // 🧩 Custom Fields
  final bool hasWarranty;
  final DateTime? expiryDate;

  String get imageUrl =>
      images.isNotEmpty ? images.first : 'https://via.placeholder.com/200';
  final String? barcode;
  final bool isFeatured;

  const Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.sku,
    required this.sellingType,
    required this.category,
    required this.subCategory,
    required this.brand,
    required this.unit,
    required this.quantity,
    required this.price,
    required this.quantityAlert,
    required this.images,
    this.salePrice,
    this.description,
    this.hasWarranty = false,
    this.expiryDate,

    this.isFeatured = false,
    this.barcode,
  });

  // Get unique categories
  static List<String> get categories {
    final cats = productsList.map((p) => p.category).toSet().toList();
    return ['All', ...cats];
  }
}
