part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialProducts extends ProductEvent {}

class LoadProductById extends ProductEvent {
  final int id;
  LoadProductById(this.id);

  @override
  List<Object?> get props => [id];
}

class FilterProductsByCategory extends ProductEvent {
  final String category;
  FilterProductsByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchProducts extends ProductEvent {
  final String products;

  SearchProducts(this.products);

  @override
  List<Object?> get props => [products];
}
