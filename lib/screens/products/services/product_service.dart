import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../screens/products/model/product.dart';

/// Product API Service - Handles all HTTP calls for products
class ProductService {
  /// Get all products with optional filtering
  Future<List<Product>> getProducts({
    String? category,
    String? search,
    bool? featured,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (category != null && category != 'All') {
        queryParams['category'] = category;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (featured == true) {
        queryParams['featured'] = 'true';
      }

      final uri = Uri.parse(
        ApiConstants.products,
      ).replace(queryParameters: queryParams);

      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              debugPrint('[ProductService] REQUEST TIMEOUT after 15 seconds!');
              throw Exception(
                'Request timeout - check your internet connection',
              );
            },
          );

      if (response.statusCode == 200) {
        dynamic data;
        try {
          data = jsonDecode(response.body);
        } catch (e, stack) {
          rethrow;
        }

        final List<dynamic> productsJson = data['data'] ?? [];

        final List<Product> products = [];
        for (int i = 0; i < productsJson.length; i++) {
          try {
            products.add(Product.fromJson(productsJson[i]));
          } catch (e) {
            rethrow;
          }
        }
        return products;
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get single product by ID
  Future<Product?> getProductById(String id) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.productById(id)),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Product.fromJson(data['data']);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get product by barcode
  Future<Product?> getProductByBarcode(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.productByBarcode(barcode)),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Product.fromJson(data['data']);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception(
          'Failed to find product by barcode: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error fetching product by barcode: $e');
      rethrow;
    }
  }

  /// Get all categories
  Future<List<String>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.categories),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> categories = data['data'] ?? [];
        return categories.map((c) => c.toString()).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      rethrow;
    }
  }

  /// Create new product (requires admin token)
  Future<Product> createProduct(Product product, String token) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.products),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Product.fromJson(data['data']);
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Failed to create product');
      }
    } catch (e) {
      debugPrint('Error creating product: $e');
      rethrow;
    }
  }

  /// Update product (requires admin token)
  Future<Product> updateProduct(
    String id,
    Product product,
    String token,
  ) async {
    try {
      final response = await http.put(
        Uri.parse(ApiConstants.productById(id)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Product.fromJson(data['data']);
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Failed to update product');
      }
    } catch (e) {
      debugPrint('Error updating product: $e');
      rethrow;
    }
  }

  /// Delete product (requires admin token)
  Future<bool> deleteProduct(String id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse(ApiConstants.productById(id)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Product deleted successfully');
        return true;
      } else {
        debugPrint('Product deleted failed ${response.statusCode}');

        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Failed to delete product');
      }
    } catch (e) {
      debugPrint('Error deleting product: $e');
      rethrow;
    }
  }
}
