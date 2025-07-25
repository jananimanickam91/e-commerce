part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialCart extends CartEvent {}

class AddToCart extends CartEvent {
  final Product product;
  AddToCart(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveFromCart extends CartEvent {
  final Product product;
  RemoveFromCart(this.product);

  @override
  List<Object?> get props => [product];
}

class UpdateQuantity extends CartEvent {
  final Product product;
  final int quantity;
  UpdateQuantity(this.product, this.quantity);

  @override
  List<Object?> get props => [product, quantity];
}

class ClearCart extends CartEvent {}
