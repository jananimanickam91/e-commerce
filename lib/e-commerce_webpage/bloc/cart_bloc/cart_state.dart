part of 'cart_bloc.dart';

enum CartStatus { initial, loading, loaded, error, success, failure }

final class CartState extends Equatable {
  final CartStatus status;
  final List<CartItem> items;
  final double totalAmount;
  final int totalItems;
  final String? message;
  const CartState({required this.status, required this.items, required this.totalAmount, required this.totalItems, this.message});

  static final initial = CartState(status: CartStatus.initial, items: const [], message: '', totalAmount: 0, totalItems: 0);

  CartState copyWith({
    CartStatus Function()? status,
    List<CartItem> Function()? items,
    double Function()? totalAmount,
    int Function()? totalItems,
    String Function()? message,
  }) {
    return CartState(
      status: status != null ? status() : this.status,
      items: items != null ? items() : this.items,
      message: message != null ? message() : this.message,
      totalAmount: totalAmount != null ? totalAmount() : this.totalAmount,
      totalItems: totalItems != null ? totalItems() : this.totalItems,
    );
  }

  @override
  List<Object?> get props => [status, items, totalAmount, totalItems, message];
}
