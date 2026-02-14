import 'package:dream_pos/screens/pos/models/cart_item_model.dart';
import 'package:dream_pos/screens/products/services/cart_service.dart';
import 'package:dream_pos/utils/api_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartNotifier extends AsyncNotifier<List<CartItem>> {
  @override
  Future<List<CartItem>> build() async {
    final result = await CartService().getCart();
    if (result is Success<List<CartItem>>) {
      return result.data;
    } else if (result is Failure<List<CartItem>>) {
      throw Failure(message: result.message ?? "Failed to fetch cart");
    } else {
      throw Failure(message: "Unexpected result type");
    }
  }
}

final cartProvider = AsyncNotifierProvider<CartNotifier, List<CartItem>>(() {
  return CartNotifier();
});
