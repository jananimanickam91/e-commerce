import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:example_code/products_page/views/mobile/category_page/category_chip.dart';
import 'package:example_code/products_page/views/mobile/category_page/category_product.dart';
import 'package:example_code/products_page/views/mobile/product_detail_page/product_card.dart';
import 'package:example_code/theme/theme_configration.dart';
import 'package:example_code/products_page/views/mobile/cart_page/cart_screen.dart';
import 'package:example_code/products_page/views/mobile/widgets/favourite_page/fav_screen.dart';
import 'package:example_code/products_page/views/mobile/widgets/profile_page/profile_page.dart';
import '../product_detail_page/product_detail_screen.dart';
import '../../../bloc/product_bloc.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ProductBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = context.read<ProductBloc>();
    _homeBloc.add(LoadHomeData());
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final state = _homeBloc.state;
      if (state.status == ProductStatus.loaded && !state.isLoadingMore && state.hasMoreProducts && _searchController.text.isEmpty) {
        _homeBloc.add(LoadMoreProducts());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        List<Widget> screens = [_buildHomeContent(state), const CartScreen(), const FavoritesScreen(), const ProfileScreen()];

        int currentIndex = state.currentIndex;

        return Scaffold(
          appBar:
              currentIndex == 0
                  ? AppBar(
                    title: const Text('Cartify'),
                    backgroundColor: Colors.white,
                    elevation: 0,
                    actions: [IconButton(icon: const Icon(Icons.notifications_none_outlined), onPressed: () {})],
                  )
                  : null,
          body:
              currentIndex == 0
                  ? _buildHomeContent(state)
                  : (screens.isNotEmpty && currentIndex < screens.length ? screens[currentIndex] : const Center(child: CircularProgressIndicator())),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: (index) {
              _homeBloc.add(ChangeBottomNavIndex(index));
            },
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: AppTheme.textSecondary,
            backgroundColor: Colors.white,
            elevation: 8,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'Cart'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), activeIcon: Icon(Icons.favorite), label: 'Favorites'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHomeContent(ProductState state) {
    if (state.status == ProductStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == ProductStatus.failure) {
      return _buildErrorWidget(state.message ?? 'Something went wrong');
    }
    if (state.status == ProductStatus.success || state.status == ProductStatus.loaded) {
      return RefreshIndicator(
        onRefresh: () async {
          _homeBloc.add(RefreshData());
        },
        color: AppTheme.primaryColor,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(state),
                const SizedBox(height: 10),
                _buildPromoBanner(),
                const SizedBox(height: 10),
                _buildCategoriesSection(state),
                const SizedBox(height: 10),
                _buildProductsSection(state),
                if (state.isLoadingMore) _buildLoadingMore(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppTheme.errorColor),
            const SizedBox(height: 16),
            Text('Oops! Something went wrong', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(error, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () => _homeBloc.add(LoadHomeData()), child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        double bannerHeight = screenHeight * 0.22;
        if (bannerHeight > 180) bannerHeight = 180;
        if (bannerHeight < 140) bannerHeight = 140;

        double horizontalPadding = screenWidth * 0.04;
        if (horizontalPadding > 20) horizontalPadding = 20;
        if (horizontalPadding < 10) horizontalPadding = 10;

        double verticalPadding = bannerHeight * 0.08;
        if (verticalPadding > 16) verticalPadding = 16;
        if (verticalPadding < 8) verticalPadding = 8;

        double titleFontSize = screenWidth * 0.055;
        if (titleFontSize > 24) titleFontSize = 24;
        if (titleFontSize < 18) titleFontSize = 18;

        double subtitleFontSize = screenWidth * 0.035;
        if (subtitleFontSize > 14) subtitleFontSize = 14;
        if (subtitleFontSize < 11) subtitleFontSize = 11;

        double buttonFontSize = screenWidth * 0.03;
        if (buttonFontSize > 12) buttonFontSize = 12;
        if (buttonFontSize < 10) buttonFontSize = 10;

        double iconSize = bannerHeight * 0.3;
        if (iconSize > 60) iconSize = 60;
        if (iconSize < 35) iconSize = 35;

        return Container(
          width: double.infinity,
          height: bannerHeight,
          margin: const EdgeInsets.symmetric(horizontal: 0),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: const Color(0xFFFF6B35).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: Row(
            children: [
              Expanded(
                flex: screenWidth < 350 ? 2 : 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Super Sale',
                          style: TextStyle(color: Colors.white, fontSize: titleFontSize, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Discount',
                          style: TextStyle(color: Colors.white, fontSize: titleFontSize, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(height: bannerHeight * 0.02),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Up to 50%',
                          style: TextStyle(color: Colors.white, fontSize: subtitleFontSize, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(height: bannerHeight * 0.03),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: bannerHeight * 0.03),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Shop Now',
                            style: TextStyle(color: const Color(0xFFFF6B35), fontWeight: FontWeight.bold, fontSize: buttonFontSize),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: screenWidth < 350 ? 1 : 2,
                child: Container(
                  height: bannerHeight * 0.5,
                  margin: EdgeInsets.only(left: horizontalPadding * 0.5),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Icon(Icons.shopping_bag, color: Colors.white, size: iconSize)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingMore() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(color: AppTheme.primaryColor),
            const SizedBox(height: 8),
            Text('Loading more products...', style: TextStyle(color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(ProductState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (query) => _homeBloc.add(FilterProducts(query)),
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.primaryColor, width: 2)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(ProductState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categories', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CategoryChip(
                  category: state.categories[index],
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryProductsScreen(category: state.categories[index])));
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductsSection(ProductState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Featured Products', style: Theme.of(context).textTheme.titleLarge),
            TextButton(onPressed: () {}, child: const Text('View All')),
          ],
        ),
        const SizedBox(height: 12),
        state.filteredProducts.isEmpty
            ? Center(
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 48, color: AppTheme.textSecondary),
                  const SizedBox(height: 16),
                  Text('No products found', style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            )
            : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: state.filteredProducts.length,
              itemBuilder: (context, index) {
                final product = state.filteredProducts[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)));
                  },
                );
              },
            ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
