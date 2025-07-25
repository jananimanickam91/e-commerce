import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:example_code/e-commerce_webpage/model/product_model.dart';
import 'package:example_code/e-commerce_webpage/repo/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;
  final List<Product> _allProducts = [];
  ProductBloc({required ProductRepository repository}) : _repository = repository, super(ProductState.initial) {
    on<InitialProducts>(_onInitialProducts);
    on<FilterProductsByCategory>(_onFilterProductsByCategory);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onInitialProducts(InitialProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: () => ProductStatus.loading));
    try {
      final List<Product> product = await _repository.getProducts();
      final trending = List<Product>.from(product)..sort((a, b) => b.rating.rate.compareTo(a.rating.rate));
      final topTrending = trending.take(4).toList();
      _allProducts.clear();
      _allProducts.addAll(product);
      emit(
        state.copyWith(
          product: () => product,
          filteredProducts: () => product,
          selectedCategory: () => 'Home',
          trendingProducts: () => topTrending,
          status: () => ProductStatus.loaded,
        ),
      );
    } catch (error) {
      emit(state.copyWith(status: () => ProductStatus.failure, message: () => "Error Loading Data"));
    }
  }

  Future<void> _onFilterProductsByCategory(FilterProductsByCategory event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: () => ProductStatus.loading));
    try {
      List<Product> filteredProducts;

      if (event.category == 'Home') {
        filteredProducts = _allProducts;
      } else {
        final mappedCategory = _mapCategory(event.category);
        filteredProducts = await _repository.getProductsByCategory(mappedCategory);
      }

      emit(state.copyWith(filteredProducts: () => filteredProducts, selectedCategory: () => event.category, status: () => ProductStatus.loaded));
    } catch (error) {
      emit(state.copyWith(status: () => ProductStatus.failure, message: () => "Error Filtering Products: ${error.toString()}"));
    }
  }

  String _mapCategory(String uiCategory) {
    switch (uiCategory.toLowerCase()) {
      case 'men':
        return "men's clothing";
      case 'women':
        return "women's clothing";
      case 'accessories':
        return "jewelery";
      case 'electronics':
        return "electronics";
      default:
        return "home";
    }
  }

  Future<void> _onSearchProducts(SearchProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: () => ProductStatus.loading));
    try {
      final query = event.products.toLowerCase();
      final searchResults = _allProducts.where((product) => product.title.toLowerCase().contains(query)).toList();
      emit(state.copyWith(filteredProducts: () => searchResults, status: () => ProductStatus.loaded));
    } catch (error) {
      emit(state.copyWith(status: () => ProductStatus.failure, message: () => "Error Searching Products: ${error.toString()}"));
    }
  }
}
