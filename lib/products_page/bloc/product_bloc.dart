import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:example_code/products_page/model/product_model.dart';
import 'package:example_code/products_page/repo/repo.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;
  final List<Product> _allProducts = [];

  ProductBloc({required ProductRepository repository}) : _repository = repository, super(ProductState.initial) {
    on<LoadHomeData>(_onLoadHomeData);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<LoadCategoryProducts>(_onLoadCategoryProducts);
    on<FilterProducts>(_onFilterProducts);
    on<RefreshData>(_onRefreshData);
    on<ChangeBottomNavIndex>(_onChangeBottomNavIndex);
  }

  Future<void> _onLoadHomeData(LoadHomeData event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: () => ProductStatus.loading));

    try {
      final products = await _repository.fetchProducts(limit: event.limit);
      final categories = await _repository.fetchCategories();
      _allProducts.clear();
      _allProducts.addAll(products);

      emit(
        state.copyWith(
          products: () => products,
          filteredProducts: () => products,
          categories: () => categories,
          currentLimit: () => event.limit,
          hasMoreProducts: () => products.length == event.limit,
          isLoadingMore: () => false,
          currentIndex: () => 0,
          searchQuery: () => '',
          status: () => ProductStatus.loaded,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: () => ProductStatus.failure, message: () => e.toString()));
    }
  }

  Future<void> _onLoadMoreProducts(LoadMoreProducts event, Emitter<ProductState> emit) async {
    if (state.isLoadingMore || !state.hasMoreProducts) return;

    emit(state.copyWith(isLoadingMore: () => true));

    try {
      final newLimit = state.currentLimit + event.loadMoreLimit;
      final products = await _repository.fetchProducts(limit: newLimit);
      _allProducts.clear();
      _allProducts.addAll(products);

      emit(
        state.copyWith(
          products: () => products,
          filteredProducts: () => products,
          currentLimit: () => newLimit,
          hasMoreProducts: () => products.length == newLimit,
          isLoadingMore: () => false,
          status: () => ProductStatus.loaded,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoadingMore: () => false));
    }
  }

  void _onFilterProducts(FilterProducts event, Emitter<ProductState> emit) {
    final query = event.query.toLowerCase();

    final filtered =
        _allProducts.where((product) {
          return product.title.toLowerCase().contains(query) || product.category.toLowerCase().contains(query);
        }).toList();

    emit(state.copyWith(filteredProducts: () => filtered, searchQuery: () => event.query, status: () => ProductStatus.loaded));
  }

  Future<void> _onLoadCategoryProducts(LoadCategoryProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: () => ProductStatus.loading));

    try {
      final products = await _repository.fetchProductsByCategory(event.category);
      emit(state.copyWith(filteredProducts: () => products, selectedCategory: () => event.category, status: () => ProductStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: () => ProductStatus.failure, message: () => 'Failed to load ${event.category} products'));
    }
  }

  Future<void> _onRefreshData(RefreshData event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: () => ProductStatus.loading));

    try {
      final products = await _repository.fetchProducts(limit: 6);
      final categories = await _repository.fetchCategories();
      _allProducts.clear();
      _allProducts.addAll(products);

      emit(
        state.copyWith(
          products: () => products,
          filteredProducts: () => products,
          categories: () => categories,
          currentLimit: () => 6,
          hasMoreProducts: () => products.length == 6,
          searchQuery: () => '',
          status: () => ProductStatus.loaded,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: () => ProductStatus.failure, message: () => e.toString()));
    }
  }

  void _onChangeBottomNavIndex(ChangeBottomNavIndex event, Emitter<ProductState> emit) {
    emit(state.copyWith(currentIndex: () => event.index));
  }
}
