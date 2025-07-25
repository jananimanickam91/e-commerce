part of 'product_bloc.dart';

enum ProductStatus { initial, loading, loaded, error, success, failure }

final class ProductState extends Equatable {
  final ProductStatus status;
  final List<Product> products;
  final List<Product> filteredProducts;
  final List<String> categories;
  final int currentLimit;
  final bool hasMoreProducts;
  final bool isLoadingMore;
  final int currentIndex;
  final String searchQuery;
  final String? message;
  final String selectedCategory;

  const ProductState({
    required this.status,
    required this.products,
    required this.filteredProducts,
    required this.categories,
    required this.currentLimit,
    required this.hasMoreProducts,
    required this.isLoadingMore,
    required this.currentIndex,
    required this.searchQuery,
    this.message,
    required this.selectedCategory,
  });

  static final initial = ProductState(
    status: ProductStatus.initial,
    products: const [],
    filteredProducts: const [],
    categories: const [],
    currentLimit: 6,
    hasMoreProducts: true,
    isLoadingMore: false,
    currentIndex: 0,
    searchQuery: '',
    message: '',
    selectedCategory: '',
  );

  ProductState copyWith({
    ProductStatus Function()? status,
    List<Product> Function()? products,
    List<Product> Function()? filteredProducts,
    List<String> Function()? categories,
    int Function()? currentLimit,
    bool Function()? hasMoreProducts,
    bool Function()? isLoadingMore,
    int Function()? currentIndex,
    String Function()? searchQuery,
    String Function()? message,
    String Function()? selectedCategory,
  }) {
    return ProductState(
      status: status != null ? status() : this.status,
      products: products != null ? products() : this.products,
      filteredProducts: filteredProducts != null ? filteredProducts() : this.filteredProducts,
      categories: categories != null ? categories() : this.categories,
      currentLimit: currentLimit != null ? currentLimit() : this.currentLimit,
      hasMoreProducts: hasMoreProducts != null ? hasMoreProducts() : this.hasMoreProducts,
      isLoadingMore: isLoadingMore != null ? isLoadingMore() : this.isLoadingMore,
      currentIndex: currentIndex != null ? currentIndex() : this.currentIndex,
      searchQuery: searchQuery != null ? searchQuery() : this.searchQuery,
      message: message != null ? message() : this.message,
      selectedCategory: selectedCategory != null ? selectedCategory() : this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    filteredProducts,
    categories,
    currentLimit,
    hasMoreProducts,
    isLoadingMore,
    currentIndex,
    searchQuery,
    message,
    selectedCategory,
  ];
}
