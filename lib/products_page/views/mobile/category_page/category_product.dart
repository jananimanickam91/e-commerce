import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:example_code/products_page/bloc/product_bloc.dart';
import 'package:example_code/products_page/model/product_model.dart';
import 'package:example_code/products_page/views/mobile/product_detail_page/product_card.dart';
import 'package:example_code/theme/theme_configration.dart';
import '../product_detail_page/product_detail_screen.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String category;

  const CategoryProductsScreen({super.key, required this.category});

  String _capitalizeCategory(String category) {
    return category.split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '').join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ProductBloc>(context)..add(LoadCategoryProducts(category)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_capitalizeCategory(category)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppTheme.textPrimary),
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state.status == ProductStatus.loading) {
              return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
            } else if (state.status == ProductStatus.failure) {
              return _buildErrorWidget(context, state.message ?? 'Unknown error', () {
                context.read<ProductBloc>().add(LoadCategoryProducts(category));
              });
            } else if (state.filteredProducts.isEmpty) {
              return _buildEmptyWidget(context);
            } else {
              return _buildProductsGrid(context, state.filteredProducts, category);
            }
          },
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error, VoidCallback onRetry) {
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
            ElevatedButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: AppTheme.textSecondary),
          const SizedBox(height: 16),
          Text('No products found', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Try browsing other categories', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(BuildContext context, List<Product> products, String category) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductBloc>().add(LoadCategoryProducts(category));
      },
      color: AppTheme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.accentColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _capitalizeCategory(category),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${products.length} products available',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withOpacity(0.9)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    product: product,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
