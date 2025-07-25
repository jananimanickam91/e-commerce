import 'package:badges/badges.dart' as badges;
import 'package:example_code/e-commerce_webpage/bloc/cart_bloc/cart_bloc.dart';
import 'package:example_code/e-commerce_webpage/bloc/product_bloc/product_bloc.dart';
import 'package:example_code/e-commerce_webpage/model/product_model.dart';
import 'package:example_code/e-commerce_webpage/views/cart_page.dart';
import 'package:example_code/login/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey[100],
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Text('Home', style: TextStyle(color: Colors.grey[600])),
                Text(' / ', style: TextStyle(color: Colors.grey[600])),
                Text('Product Details', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),

          Container(
            color: Colors.green[100],
            padding: EdgeInsets.all(40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          padding: EdgeInsets.all(8),
                          child: Column(
                            spacing: 8.0,
                            children: [
                              _buildThumbnail(widget.product.image, true),
                              _buildThumbnail(widget.product.image, false),
                              _buildThumbnail(widget.product.image, false),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: CachedNetworkImage(
                              imageUrl: widget.product.image,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 40),

                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.product.title, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
                      SizedBox(height: 8),
                      Text('by ${widget.product.category}', style: TextStyle(fontSize: 16, color: Colors.black.withValues(alpha: 0.8))),
                      SizedBox(height: 24),
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(height: 16),

                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(index < widget.product.rating.rate.floor() ? Icons.star : Icons.star_border, color: Colors.amber, size: 20);
                          }),
                          SizedBox(width: 8),
                          Text('(${widget.product.rating.count} Reviews)', style: TextStyle(color: Colors.black.withValues(alpha: 0.8))),
                        ],
                      ),
                      SizedBox(height: 32),

                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          return Row(
                            children: [
                              ElevatedButton(
                                onPressed:
                                    state.status == CartStatus.loading
                                        ? null
                                        : () {
                                          context.read<CartBloc>().add(AddToCart(widget.product));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('${widget.product.title} added to cart', style: TextStyle(color: Colors.black)),
                                              duration: Duration(seconds: 2),
                                              backgroundColor: Colors.green[200],
                                            ),
                                          );
                                        },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                ),
                                child:
                                    state.status == CartStatus.loading
                                        ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.green[100], strokeWidth: 2))
                                        : Text('Add To Cart', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[400])),
                              ),
                              SizedBox(width: 16),
                              Container(
                                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border, color: Colors.green[400])),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.green[300],
              labelColor: Colors.green[300],
              unselectedLabelColor: Colors.grey[600],
              tabs: [Tab(text: 'Description'), Tab(text: 'Author'), Tab(text: 'Comments'), Tab(text: 'Review')],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Text(widget.product.description, style: TextStyle(fontSize: 16, height: 1.6, color: Colors.grey[700])),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Text('Author information for ${widget.product.title}', style: TextStyle(fontSize: 16, height: 1.6, color: Colors.grey[700])),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Text('Customer comments will appear here.', style: TextStyle(fontSize: 16, height: 1.6, color: Colors.grey[700])),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer Reviews', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                      SizedBox(height: 16),
                      Text(
                        'Rating: ${widget.product.rating.rate}/5.0 (${widget.product.rating.count} reviews)',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(String imageUrl, bool isSelected) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? Colors.red : Colors.grey[300]!, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
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
        Navigator.pop(context);
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
}
