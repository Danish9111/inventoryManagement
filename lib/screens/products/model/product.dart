
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

  factory Product.empty() => const Product(
    id: '',
    name: '',
    slug: '',
    sku: '',
    sellingType: '',
    category: '',
    subCategory: '',
    brand: '',
    unit: '',
    quantity: 0,
    price: 0,
    quantityAlert: 0,
    images: [],
  );

  /// Create Product from JSON (API response)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      sku: json['sku'] ?? '',
      sellingType: json['sellingType'] ?? 'Both',
      category: json['category'] ?? '',
      subCategory: json['subCategory'] ?? '',
      brand: json['brand'] ?? '',
      unit: json['unit'] ?? 'Pc',
      quantity: (json['quantity'] ?? 0).toInt(),
      price: (json['price'] ?? 0).toDouble(),
      salePrice: json['salePrice'] != null
          ? (json['salePrice']).toDouble()
          : null,
      quantityAlert: (json['quantityAlert'] ?? 10).toInt(),
      description: json['description'],
      images: List<String>.from(json['images'] ?? []),
      barcode: json['barcode'],
      isFeatured: json['isFeatured'] ?? false,
      hasWarranty: json['hasWarranty'] ?? false,
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'])
          : null,
    );
  }

  /// Convert Product to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'sku': sku,
      'sellingType': sellingType,
      'category': category,
      'subCategory': subCategory,
      'brand': brand,
      'unit': unit,
      'quantity': quantity,
      'price': price,
      if (salePrice != null) 'salePrice': salePrice,
      'quantityAlert': quantityAlert,
      if (description != null) 'description': description,
      'images': images,
      if (barcode != null) 'barcode': barcode,
      'isFeatured': isFeatured,
      'hasWarranty': hasWarranty,
      if (expiryDate != null) 'expiryDate': expiryDate!.toIso8601String(),
    };
  }

  /// CopyWith for immutable updates
  Product copyWith({
    String? id,
    String? name,
    String? slug,
    String? sku,
    String? sellingType,
    String? category,
    String? subCategory,
    String? brand,
    String? unit,
    int? quantity,
    double? price,
    double? salePrice,
    int? quantityAlert,
    String? description,
    List<String>? images,
    String? barcode,
    bool? isFeatured,
    bool? hasWarranty,
    DateTime? expiryDate,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      sku: sku ?? this.sku,
      sellingType: sellingType ?? this.sellingType,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      brand: brand ?? this.brand,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      quantityAlert: quantityAlert ?? this.quantityAlert,
      description: description ?? this.description,
      images: images ?? this.images,
      barcode: barcode ?? this.barcode,
      isFeatured: isFeatured ?? this.isFeatured,
      hasWarranty: hasWarranty ?? this.hasWarranty,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }
}
