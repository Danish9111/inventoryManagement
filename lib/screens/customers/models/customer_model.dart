class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final double totalSpent;
  final int loyaltyPoints;
  final String? imageUrl;
  final String createdAt;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.totalSpent,
    required this.loyaltyPoints,
    this.imageUrl,
    required this.createdAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      totalSpent: (json['totalSpent'] ?? 0.0).toDouble(),
      loyaltyPoints: json['loyaltyPoints'] ?? 0,
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'totalSpent': totalSpent,
      'loyaltyPoints': loyaltyPoints,
      'createdAt': createdAt,
    };
  }

  Customer copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    double? totalSpent,
    int? loyaltyPoints,
    String? imageUrl,
  }) {
    return Customer(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      totalSpent: totalSpent ?? this.totalSpent,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt,
    );
  }
}
