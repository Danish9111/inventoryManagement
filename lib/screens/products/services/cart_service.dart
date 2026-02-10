import 'dart:convert';

import 'package:dream_pos/constants/api_constants.dart';
import 'package:dream_pos/screens/pos/models/cart_item_model.dart';
import 'package:dream_pos/services/auth_service.dart';
import 'package:dream_pos/utils/api_result.dart';
import 'package:http/http.dart' as http;

class CartService {
  Future<ApiResult<List<CartItem>>> getCart() async {
    final token = await AuthService().getToken();
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.cart),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> itemsJson = jsonBody['data']['items'] ?? [];
        final List<CartItem> items = itemsJson
            .map((item) => CartItem.fromJson(item))
            .toList();
        return Success(data: items);
      } else {
        return Failure(
          message: "Failed to fetch cart",
          statusCode: response.statusCode,
          error: jsonBody['message'],
        );
      }
    } catch (e) {
      return Failure(message: "Failed to fetch cart", error: e);
    }
  }
}
