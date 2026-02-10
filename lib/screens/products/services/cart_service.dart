import 'package:dream_pos/constants/api_constants.dart';
import 'package:dream_pos/services/auth_service.dart';
import 'package:http/http.dart' as http;

class CartService {
  Future<void> getCart() async {
    final token = await AuthService().getToken();
    try {
      print('Fetching cart from ${ApiConstants.cart}...');
      final response = await http.get(
        Uri.parse(ApiConstants.cart),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
      } else {
        print('Failed to load cart: ${response.body}');
      }
    } catch (e) {
      print('Error request: $e');
    }
  }
}

void main() async {
  final service = CartService();
  await service.getCart();
}
