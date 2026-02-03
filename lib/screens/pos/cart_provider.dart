import 'package:dream_pos/screens/pos/models/cartState.dart';
import 'package:dream_pos/screens/pos/models/cart_item_model.dart';
import 'package:dream_pos/screens/pos/models/order_model.dart';
import 'package:dream_pos/screens/products/model/product.dart';
import 'package:flutter_riverpod/legacy.dart';

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());

  void addToCart(Product product) {
    final existingIndex = state.cartItems.indexWhere(
      (i) => i.product.id == product.id,
    );

    List<CartItem> updated = [...state.cartItems];
    if (existingIndex >= 0) {
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: updated[existingIndex].quantity + 1,
      );
    } else {
      updated.add(CartItem(product: product));
    }
    state = state.copyWith(cartItems: updated);
  }

  // Increment quantity
  void increment(String productId) {
    List<CartItem> updated = state.cartItems.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();

    state = state.copyWith(cartItems: updated);
  }

  // Decrement quantity
  void decrement(String productId) {
    List<CartItem> updated = [];
    for (var item in state.cartItems) {
      if (item.product.id == productId) {
        if (item.quantity > 1) {
          updated.add(item.copyWith(quantity: item.quantity - 1));
        }
      } else {
        updated.add(item);
      }
    }
    state = state.copyWith(cartItems: updated);
  }

  void remove(String productId) {
    state = state.copyWith(
      cartItems: state.cartItems
          .where((item) => item.product.id != productId)
          .toList(),
    );
  }

  void clearCart() {
    state = state.copyWith(cartItems: [], discount: null);
  }

  void applyDiscount(Discount? discount) {
    state = state.copyWith(discount: discount);
  }

  void setCustomer(String name) {
    state = state.copyWith(selectedCustomer: name);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>(
  (ref) => CartNotifier(),
);
