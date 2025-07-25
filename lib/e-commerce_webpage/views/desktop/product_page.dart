import 'package:example_code/e-commerce_webpage/bloc/cart_bloc/cart_bloc.dart';
import 'package:example_code/e-commerce_webpage/bloc/product_bloc/product_bloc.dart';
import 'package:example_code/e-commerce_webpage/model/product_model.dart';
import 'package:example_code/e-commerce_webpage/views/desktop/cart_page.dart';
import 'package:example_code/e-commerce_webpage/views/desktop/product_details.page.dart';
import 'package:example_code/login/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state.status == ProductStatus.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.status == ProductStatus.loaded) {
            return SingleChildScrollView(child: Column(children: [_buildProductBasedOnCategory(context, state), _buildFooterSection()]));
          } else if (state.status == ProductStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(InitialProducts());
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildProductBasedOnCategory(BuildContext context, ProductState state) {
    if (state.selectedCategory == 'Home') {
      return Column(children: [_buildMainSection(), _buildTrendingSection(), _buildNewArrivalSection()]);
    } else {
      return Column(children: [_buildCategoryHeader(state.selectedCategory), _buildProduct(context, state.filteredProducts)]);
    }
  }

  Widget _buildFooterSection() {
    return Container(
      width: double.infinity,
      color: Colors.grey[100],
      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFooterItem(
            Icons.local_shipping_outlined,
            'NEXT DAY SHIPPING',
            'We offer fast and reliable next-day delivery\non all orders placed before 5 PM.\nAvailable across major cities.',
          ),
          _buildFooterItem(
            Icons.refresh,
            'FREE 20-DAY RETURNS',
            'Shop with confidence. Return or exchange\nitems within 20 days — no questions asked.\nHassle-free process guaranteed.',
          ),
          _buildFooterItem(
            Icons.lock_outline,
            'SECURE CHECKOUT',
            'Your payment information is protected\nwith end-to-end encryption and SSL.\nShop safely and securely.',
          ),
        ],
      ),
    );
  }

  Widget _buildFooterItem(IconData icon, String title, String description) {
    return SizedBox(
      width: 300,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Icon(icon, size: 24, color: Colors.black54),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 0.5)),
                SizedBox(height: 8),
                Text(description, style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String category) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      child: Column(
        children: [
          Text('$category Products', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)),
          SizedBox(height: 8),
          Container(height: 4, width: 60, decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(2))),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 120,
      leading: Container(
        width: 100,
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Text('Cartify', style: TextStyle(color: Colors.green[200], fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1.0)),
        ),
      ),
      title: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNavItem(context, 'Home', state.selectedCategory == 'Home'),
              _buildNavItem(context, 'Men', state.selectedCategory == 'Men'),
              _buildNavItem(context, 'Women', state.selectedCategory == 'Women'),
              _buildNavItem(context, 'Accessories', state.selectedCategory == 'Accessories'),
              _buildNavItem(context, 'Electronics', state.selectedCategory == 'Electronics'),
            ],
          );
        },
      ),
      actions: [
        Container(
          width: 200,
          height: 40,
          margin: EdgeInsets.symmetric(vertical: 4),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 20),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey[300]!)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey[300]!)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.green.shade100, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            style: TextStyle(fontSize: 14),
            onChanged: (value) {
              context.read<ProductBloc>().add(SearchProducts(value));
            },
          ),
        ),
        SizedBox(width: 8),
        IconButton(icon: Icon(Icons.favorite_border, color: Colors.black), onPressed: () {}),
        IconButton(
          icon: Icon(Icons.person, color: Colors.black),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.status == CartStatus.loaded) {
              return badges.Badge(
                badgeContent: Text(state.totalItems.toString(), style: TextStyle(color: Colors.white, fontSize: 12)),
                showBadge: state.totalItems > 0,
                child: IconButton(
                  icon: Icon(Icons.shopping_cart, color: Colors.black),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
                  },
                ),
              );
            }
            return IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.black),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
              },
            );
          },
        ),
        SizedBox(width: 16),
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, String title, bool isActive) {
    return GestureDetector(
      onTap: () {
        context.read<ProductBloc>().add(FilterProductsByCategory(title));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          title,
          style: TextStyle(color: isActive ? Colors.red : Colors.black, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildMainSection() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.green[100]!, Colors.blue[50]!], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 300,
            top: 0,
            bottom: 0,
            child: Container(width: 300, decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/image1.png")))),
          ),
          Positioned(
            left: 300,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Kids Fashion Sale', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.w500)),
                  SizedBox(height: 8),
                  Text('New Arrival', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.2)),
                  SizedBox(height: 16),
                  Text(
                    'Discover the latest trends in minimal kids\'s fashion.\nExplore our curated collection of stylish essentials.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('SHOP NOW', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingSection() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.trendingProducts.isEmpty) return SizedBox();

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 40),
          child: Column(
            children: [
              Text('Trending Products', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                    state.trendingProducts.map((product) {
                      return _buildTrendingProduct(product.title, product.image, '\$${product.price.toStringAsFixed(2)}', '');
                    }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrendingProduct(String title, String imageUrl, String price, String originalPrice) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text(price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
              SizedBox(width: 8),
              Text(originalPrice, style: TextStyle(fontSize: 14, color: Colors.grey[500], decoration: TextDecoration.lineThrough)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewArrivalSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      child: Column(
        children: [
          Text('Feature Products', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFilterTab('All', true),
              _buildFilterTab('Women', false),
              _buildFilterTab('Men', false),
              _buildFilterTab('Accessories', false),
            ],
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildArrivalProduct(
                'Premium Polo Shirt',
                'https://images.unsplash.com/photo-1586790170083-2f9ceadc732d?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
                '\$45.00',
                '\$55.00',
              ),
              _buildArrivalProduct(
                'Casual Hoodie',
                'https://images.unsplash.com/photo-1556821840-3a63f95609a7?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
                '\$32.00',
                '\$40.00',
              ),
              _buildArrivalProduct(
                'Denim Jacket',
                'https://images.unsplash.com/photo-1551488831-00ddcb6c6bd3?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
                '\$68.00',
                '\$80.00',
              ),
              _buildArrivalProduct(
                'Sport Hoodie',
                'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
                '\$42.00',
                '\$50.00',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String title, bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.red : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? Colors.red : Colors.grey[300]!),
      ),
      child: Text(title, style: TextStyle(color: isActive ? Colors.white : Colors.grey[600], fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildArrivalProduct(String title, String imageUrl, String price, String originalPrice) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text(price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
              SizedBox(width: 8),
              Text(originalPrice, style: TextStyle(fontSize: 14, color: Colors.grey[500], decoration: TextDecoration.lineThrough)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProduct(BuildContext context, List<Product> products) {
    if (products.isEmpty) {
      return Container(
        padding: EdgeInsets.all(60),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('No products found', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(60),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.8, crossAxisSpacing: 20, mainAxisSpacing: 20),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildProductCard(context, product);
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsPage(product: product)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: Icon(Icons.favorite_border, color: Colors.red, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text('${product.rating.rate}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        Text(' (${product.rating.count})', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        BlocBuilder<CartBloc, CartState>(
                          builder: (context, cartState) {
                            return Container(
                              decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                              child: IconButton(
                                icon: Icon(
                                  Icons.add_shopping_cart,
                                  color: cartState.status == CartStatus.loading ? Colors.grey : Colors.black,
                                  size: 20,
                                ),
                                onPressed:
                                    cartState.status == CartStatus.loading
                                        ? null
                                        : () {
                                          context.read<CartBloc>().add(AddToCart(product));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('${product.title} added to cart'),
                                              duration: Duration(seconds: 2),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
