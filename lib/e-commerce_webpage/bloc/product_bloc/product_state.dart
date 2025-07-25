part of 'product_bloc.dart';

enum ProductStatus { initial, loading, loaded, error, success, failure }

final class ProductState extends Equatable {
  final ProductStatus status;
  final List<Product> product;
  final List<Product> filteredProducts;
  final String selectedCategory;
  final List<Product> trendingProducts;
  final String? message;
  const ProductState({
    required this.status,
    required this.product,
    required this.filteredProducts,
    required this.selectedCategory,
    required this.trendingProducts,
    this.message,
  });

  static final initial = ProductState(
    status: ProductStatus.initial,
    product: const [],
    message: '',
    filteredProducts: [],
    trendingProducts: [],
    selectedCategory: '',
  );

  ProductState copyWith({
    ProductStatus Function()? status,
    List<Product> Function()? product,
    List<Product> Function()? filteredProducts,
    String Function()? selectedCategory,
    List<Product> Function()? trendingProducts,
    String Function()? message,
  }) {
    return ProductState(
      status: status != null ? status() : this.status,
      product: product != null ? product() : this.product,
      message: message != null ? message() : this.message,
      filteredProducts: filteredProducts != null ? filteredProducts() : this.filteredProducts,
      selectedCategory: selectedCategory != null ? selectedCategory() : this.selectedCategory,
      trendingProducts: trendingProducts != null ? trendingProducts() : this.trendingProducts,
    );
  }

  @override
  List<Object?> get props => [status, product, filteredProducts, selectedCategory, trendingProducts, message];
}
