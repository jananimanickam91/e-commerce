import 'package:flutter/material.dart';
import 'package:example_code/products_page/views/mobile/cart_page/cart_screen.dart';
import 'package:example_code/products_page/model/product_model.dart';
import '../cart_page/cart_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final CartService _cartService = CartService();
  int _selectedColorIndex = 0;
  int _selectedTabIndex = 0;

  final List<Color> _productColors = [
    const Color(0xFF8B4513),
    const Color(0xFF2F4F4F),
    const Color(0xFFD2691E),
    const Color(0xFF708090),
    const Color(0xFFD3D3D3),
  ];

  @override
  void initState() {
    super.initState();
    _cartService.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cartService.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [_buildProductImageSection(), _buildProductInfoCard(), const SizedBox(height: 100)]),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: _buildFixedActionButton(),
    );
  }

  Widget _buildFixedActionButton() {
    final isInCart = _cartService.isInCart(widget.product);
    final quantity = _cartService.getQuantity(widget.product);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child:
            isInCart
                ? Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.orange), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed:
                                quantity > 1
                                    ? () {
                                      _cartService.updateQuantity(widget.product, quantity - 1);
                                    }
                                    : null,
                            icon: Icon(Icons.remove, color: quantity > 1 ? Colors.orange : Colors.grey),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(quantity.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
                          ),
                          IconButton(
                            onPressed: () {
                              _cartService.updateQuantity(widget.product, quantity + 1);
                            },
                            icon: const Icon(Icons.add, color: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text('View Cart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                )
                : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _cartService.addToCart(widget.product);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Add to Cart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black87),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share feature coming soon!'), duration: Duration(seconds: 2)));
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.share, size: 18, color: Colors.black87),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to favorites!'), duration: Duration(seconds: 2)));
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.favorite_border, size: 18, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImageSection() {
    return Container(
      height: 350,
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Hero(
                tag: 'product-${widget.product.id}',
                child: Image.network(
                  widget.product.image,
                  fit: BoxFit.contain,
                  height: 250,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                        color: Colors.orange,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.image_not_supported, size: 80, color: Colors.grey));
                  },
                ),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: index == 0 ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(color: index == 0 ? Colors.black87 : Colors.grey[300], borderRadius: BorderRadius.circular(3)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProductInfoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductHeader(),
            const SizedBox(height: 20),
            _buildRatingSection(),
            const SizedBox(height: 24),
            _buildColorSelection(),
            const SizedBox(height: 24),
            _buildTabSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.product.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.3)),
        const SizedBox(height: 8),
        Text('\$${widget.product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange)),
        const SizedBox(height: 4),
        Row(
          children: [
            Text('Seller: ', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            const Text('Tariqul Islam', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(
                widget.product.rating.rate.toStringAsFixed(1),
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text('${widget.product.rating.count} Reviews', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildColorSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 12),
        Row(
          children: List.generate(
            _productColors.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColorIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _productColors[index],
                  shape: BoxShape.circle,
                  border: Border.all(color: _selectedColorIndex == index ? Colors.black87 : Colors.transparent, width: 2),
                ),
                child: _selectedColorIndex == index ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabSection() {
    return Column(
      children: [
        Row(children: [_buildTabButton('Description', 0), _buildTabButton('Specifications', 1), _buildTabButton('Reviews', 2)]),
        const SizedBox(height: 16),
        _buildTabContent(),
      ],
    );
  }

  Widget _buildTabButton(String text, int index) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: isSelected ? Colors.orange : Colors.transparent, borderRadius: BorderRadius.circular(8)),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return Text(widget.product.description, style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5));
      case 1:
        return Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.',
          style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
        );
      case 2:
        return _buildSimpleReviewsSection();
      default:
        return const SizedBox();
    }
  }

  Widget _buildSimpleReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.product.rating.rate.toStringAsFixed(1),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(width: 8),
            _buildStarRating(widget.product.rating.rate),
            const SizedBox(width: 8),
            Text('(${widget.product.rating.count} reviews)', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          ],
        ),
        const SizedBox(height: 16),

        _buildReviewItem('Great product! Love the quality.', 5.0, 'Sarah J.'),
        _buildReviewItem('Good value for money. Fast shipping.', 4.0, 'Mike C.'),
        _buildReviewItem('Perfect! Exactly as described.', 5.0, 'Emma D.'),
        _buildReviewItem('Decent product, took time to arrive.', 3.0, 'James W.'),
      ],
    );
  }

  Widget _buildReviewItem(String comment, double rating, String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(width: 8),
              _buildStarRating(rating),
            ],
          ),
          const SizedBox(height: 4),
          Text(comment, style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(index < rating ? Icons.star : Icons.star_outline, color: index < rating ? Colors.orange : Colors.grey[400], size: 16);
      }),
    );
  }
}
