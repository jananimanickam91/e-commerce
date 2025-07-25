import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:example_code/e-commerce_webpage/model/cart_item_model.dart';
import 'package:example_code/e-commerce_webpage/model/product_model.dart';
part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState.initial) {
    on<InitialCart>(_onInitialCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onInitialCart(InitialCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: () => CartStatus.loading));
    try {
      emit(state.copyWith(items: () => [], totalAmount: () => 0.0, totalItems: () => 0, status: () => CartStatus.loaded));
    } catch (error) {
      emit(state.copyWith(status: () => CartStatus.failure, message: () => "Error Loading Data"));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: () => CartStatus.loading));
    try {
      final existingItemIndex = state.items.indexWhere((item) => item.product.id == event.product.id);

      List<CartItem> updatedItems;
      if (existingItemIndex >= 0) {
        updatedItems = List.from(state.items);
        updatedItems[existingItemIndex] = updatedItems[existingItemIndex].copyWith(quantity: updatedItems[existingItemIndex].quantity + 1);
      } else {
        updatedItems = List.from(state.items)..add(CartItem(product: event.product, quantity: 1));
      }

      _emitUpdatedCart(emit, updatedItems);
    } catch (error) {
      emit(state.copyWith(status: () => CartStatus.failure, message: () => "Error adding to cart: ${error.toString()}"));
    }
  }

  Future<void> _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: () => CartStatus.loading));
    try {
      final updatedItems = state.items.where((item) => item.product.id != event.product.id).toList();

      _emitUpdatedCart(emit, updatedItems);
    } catch (error) {
      emit(state.copyWith(status: () => CartStatus.failure, message: () => "Error removing from cart: ${error.toString()}"));
    }
  }

  Future<void> _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: () => CartStatus.loading));
    try {
      final updatedItems =
          state.items
              .map((item) {
                if (item.product.id == event.product.id) {
                  return item.copyWith(quantity: event.quantity);
                }
                return item;
              })
              .where((item) => item.quantity > 0)
              .toList();

      _emitUpdatedCart(emit, updatedItems);
    } catch (error) {
      emit(state.copyWith(status: () => CartStatus.failure, message: () => "Error updating quantity: ${error.toString()}"));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: () => CartStatus.loading));
    try {
      emit(state.copyWith(items: () => [], totalAmount: () => 0, totalItems: () => 0, status: () => CartStatus.loaded));
    } catch (error) {
      emit(state.copyWith(status: () => CartStatus.failure, message: () => "Error clearing cart: ${error.toString()}"));
    }
  }

  void _emitUpdatedCart(Emitter<CartState> emit, List<CartItem> items) {
    final totalAmount = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final totalItems = items.fold(0, (sum, item) => sum + item.quantity);

    emit(state.copyWith(items: () => items, totalAmount: () => totalAmount, totalItems: () => totalItems, status: () => CartStatus.loaded));
  }
}
