part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadHomeData extends ProductEvent {
  final int limit;

  LoadHomeData({this.limit = 6});

  @override
  List<Object?> get props => [limit];
}

class LoadMoreProducts extends ProductEvent {
  final int loadMoreLimit;

  LoadMoreProducts({this.loadMoreLimit = 6});

  @override
  List<Object?> get props => [loadMoreLimit];
}

class LoadCategoryProducts extends ProductEvent {
  final String category;

  LoadCategoryProducts(this.category);

  @override
  List<Object?> get props => [category];
}

class FilterProducts extends ProductEvent {
  final String query;

  FilterProducts(this.query);

  @override
  List<Object?> get props => [query];
}

class RefreshData extends ProductEvent {
  @override
  List<Object?> get props => [];
}

class ChangeBottomNavIndex extends ProductEvent {
  final int index;

  ChangeBottomNavIndex(this.index);

  @override
  List<Object?> get props => [index];
}
