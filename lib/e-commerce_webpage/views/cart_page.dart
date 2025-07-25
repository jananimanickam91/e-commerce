import 'package:badges/badges.dart' as badges;
import 'package:example_code/e-commerce_webpage/bloc/cart_bloc/cart_bloc.dart';
import 'package:example_code/e-commerce_webpage/bloc/product_bloc/product_bloc.dart';
import 'package:example_code/e-commerce_webpage/model/cart_item_model.dart';
import 'package:example_code/e-commerce_webpage/views/checkout_page.dart';
import 'package:example_code/login/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String selectedCountry = 'India';
  String selectedState = 'Select a State';
  String selectedShipping = 'Flat Rate: \$5.00';
  double shippingCost = 5.00;
  TextEditingController promoController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  bool showPromoField = false;
  bool showNoteField = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.status == CartStatus.loaded) {
            if (state.items.isEmpty) {
              return _buildEmptyCart();
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildCartItemsList(context, state)),
                SizedBox(width: 400, child: _buildOrderSummary(context, state)),
              ],
            );
          }
          return _buildEmptyCart();
        },
      ),
    );
  }

  Widget _buildCartItemsList(BuildContext context, CartState state) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My cart', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.grey[700])),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                return _buildCartItem(context, state.items[index]);
              },
            ),
          ),
          SizedBox(height: 24),
          _buildPromoCodeSection(),
          SizedBox(height: 16),
          _buildNoteSection(),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey[100]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: item.product.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(child: CircularProgressIndicator(strokeWidth: 2)),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${item.totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
              SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      if (item.quantity > 1) {
                        context.read<CartBloc>().add(UpdateQuantity(item.product, item.quantity - 1));
                      }
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(4)),
                      child: Icon(Icons.remove, size: 16, color: Colors.grey[600]),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 24,
                    alignment: Alignment.center,
                    child: Text('${item.quantity}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  InkWell(
                    onTap: () {
                      context.read<CartBloc>().add(UpdateQuantity(item.product, item.quantity + 1));
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(4)),
                      child: Icon(Icons.add, size: 16, color: Colors.grey[600]),
                    ),
                  ),
                  SizedBox(width: 16),
                  InkWell(
                    onTap: () {
                      context.read<CartBloc>().add(RemoveFromCart(item.product));
                    },
                    child: Icon(Icons.delete, size: 20, color: Colors.red[200]),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              showPromoField = !showPromoField;
            });
          },
          child: Row(
            children: [
              Icon(Icons.local_offer_outlined, size: 20, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text('Enter a promo code', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ],
          ),
        ),
        if (showPromoField) ...[
          SizedBox(height: 12),
          TextField(
            controller: promoController,
            decoration: InputDecoration(
              hintText: 'Enter promo code',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNoteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              showNoteField = !showNoteField;
            });
          },
          child: Row(
            children: [
              Icon(Icons.note_outlined, size: 20, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text('Add a note', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ],
          ),
        ),
        if (showNoteField) ...[
          SizedBox(height: 12),
          TextField(
            controller: noteController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add your note here...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartState state) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 5, offset: Offset(-2, 0))],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[100]!))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                    Text(
                      '\$${state.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: () {},
                  child: Text('Estimate Delivery', style: TextStyle(fontSize: 14, color: Colors.green[600], decoration: TextDecoration.underline)),
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[200]!))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
                      Text(
                        '\$${state.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckoutPage(cartItems: state.items, totalAmount: state.totalAmount)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[400],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text('Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.security, size: 16, color: Colors.green[300]),
                    SizedBox(width: 8),
                    Text('Secure Checkout', style: TextStyle(fontSize: 14, color: Colors.green[300])),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text('Your cart is empty', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[600])),
          SizedBox(height: 8),
          Text('Add some products to get started', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
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
