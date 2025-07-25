import 'package:example_code/e-commerce_webpage/model/cart_item_model.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalAmount;

  const CheckoutPage({super.key, required this.cartItems, required this.totalAmount});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _discountController = TextEditingController();

  bool _isDelivery = true;
  String _selectedCountry = 'India';
  double _discount = 0.0;
  bool _agreeToTerms = false;

  final List<String> _countries = ['India', 'United States', 'Canada', 'United Kingdom', 'Australia'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Checkout', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(icon: Icon(Icons.keyboard_arrow_left, color: Colors.black), onPressed: () => Navigator.of(context).pop()),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(32),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_buildShippingOptions(), SizedBox(height: 32), _buildShippingForm()],
                ),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildOrderSummary(),
                    SizedBox(height: 24),
                    _buildDiscountSection(),
                    SizedBox(height: 24),
                    _buildOrderTotal(),
                    SizedBox(height: 24),
                    _buildPayButton(),
                    SizedBox(height: 16),
                    _buildSecurityInfo(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shipping Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isDelivery = true),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isDelivery ? Colors.blue[50] : Colors.white,
                    border: Border.all(color: _isDelivery ? Colors.green[400]! : Colors.grey[300]!, width: _isDelivery ? 2 : 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.local_shipping_outlined, color: _isDelivery ? Colors.green[400] : Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        'Delivery',
                        style: TextStyle(
                          color: _isDelivery ? Colors.green[400] : Colors.grey[600],
                          fontWeight: _isDelivery ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isDelivery = false),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: !_isDelivery ? Colors.blue[50] : Colors.white,
                    border: Border.all(color: !_isDelivery ? Colors.green[400]! : Colors.grey[300]!, width: !_isDelivery ? 2 : 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.store_outlined, color: !_isDelivery ? Colors.green[400] : Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        'Pick up',
                        style: TextStyle(
                          color: !_isDelivery ? Colors.green[400] : Colors.grey[600],
                          fontWeight: !_isDelivery ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShippingForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(_nameController, 'Full name', 'Enter full name'),
          SizedBox(height: 16),
          _buildTextField(_emailController, 'Email address', 'Enter email address', isEmail: true),
          SizedBox(height: 16),
          _buildPhoneField(),
          SizedBox(height: 16),
          _buildCountryDropdown(),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField(_cityController, 'City', 'Enter city')),
              SizedBox(width: 16),
              Expanded(child: _buildTextField(_stateController, 'State', 'Enter state')),
              SizedBox(width: 16),
              Expanded(child: _buildTextField(_zipController, 'ZIP Code', 'Enter ZIP code')),
            ],
          ),
          SizedBox(height: 24),
          _buildTermsCheckbox(),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, {bool isEmail = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700])),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.blue[500]!, width: 2)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            if (isEmail && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Phone number *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700])),
        SizedBox(height: 8),
        TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(
            hintText: 'Enter phone number',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🇮🇳', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 8),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                ],
              ),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.blue[500]!, width: 2)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Phone number is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCountryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Country *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700])),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCountry,
          decoration: InputDecoration(
            hintText: 'Choose country',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.blue[500]!, width: 2)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          items:
              _countries.map((country) {
                return DropdownMenuItem(value: country, child: Text(country));
              }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCountry = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (value) {
            setState(() {
              _agreeToTerms = value!;
            });
          },
          activeColor: Colors.blue[600],
        ),
        Expanded(child: Text('I have read and agree to the Terms and Conditions', style: TextStyle(fontSize: 14, color: Colors.grey[700]))),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review your cart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.cartItems.length,
          separatorBuilder: (context, index) => SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = widget.cartItems[index];
            return Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.image, color: Colors.grey[400]),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.title,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text('${item.quantity}x', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Text('\$${item.totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDiscountSection() {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.local_offer_outlined, color: Colors.grey[600], size: 20),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _discountController,
                decoration: InputDecoration(hintText: 'Discount code', hintStyle: TextStyle(color: Colors.grey[400]), border: InputBorder.none),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _discount = 10.0;
                });
              },
              child: Text('Apply', style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        Divider(color: Colors.grey[300]),
      ],
    );
  }

  Widget _buildOrderTotal() {
    double subtotal = widget.totalAmount;
    double shipping = 5.0;
    double total = subtotal + shipping - _discount;

    return Column(
      children: [
        _buildTotalRow('Subtotal', subtotal),
        SizedBox(height: 8),
        _buildTotalRow('Shipping', shipping),
        if (_discount > 0) ...[SizedBox(height: 8), _buildTotalRow('Discount', -_discount, color: Colors.green)],
        SizedBox(height: 16),
        Divider(color: Colors.grey[300]),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text('\$${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalRow(String label, double amount, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Text('\$${amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 14, color: color ?? Colors.black)),
      ],
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed:
            _agreeToTerms
                ? () {
                  if (_formKey.currentState!.validate()) {
                    _showOrderConfirmation();
                  }
                }
                : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: Text('Pay Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildSecurityInfo() {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.lock_outline, color: Colors.grey[600], size: 16),
            SizedBox(width: 8),
            Text('Secure Checkout - SSL Encrypted', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Ensuring your financial and personal details are secure during every transaction.',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showOrderConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(color: Colors.green[100], shape: BoxShape.circle),
                  child: Icon(Icons.check_circle_outline, color: Colors.green[600], size: 40),
                ),
                SizedBox(height: 16),
                Text('Order Confirmed!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                Text(
                  'Your order has been placed successfully and is being processed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Continue Shopping', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
