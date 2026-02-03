import 'package:dream_pos/screens/pos/models/cart_item_model.dart';
import 'package:dream_pos/screens/pos/models/order_model.dart';

class CartState {
  final List<CartItem> cartItems;
  final Discount? discount;
  final String selectedCustomer;

  CartState({
    this.cartItems = const [],
    this.discount,
    this.selectedCustomer = '',
  });

  CartState copyWith({
    List<CartItem>? cartItems,
    Discount? discount,
    String? selectedCustomer,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      discount: discount ?? this.discount,
      selectedCustomer: selectedCustomer ?? this.selectedCustomer,
    );
  }

  double get subtotal => cartItems.fold(0, (sum, i) => sum + i.totalPrice);
  double get discountAmount => discount?.calculateDiscount(subtotal) ?? 0;
  int get totalItems => cartItems.fold(0, (sum, i) => sum + i.quantity);
}
