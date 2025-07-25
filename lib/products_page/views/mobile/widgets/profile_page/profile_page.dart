import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Map<String, dynamic> _userData = {
    'name': 'Veda',
    'email': 'veda@gmail.com',
    'phone': '+91 9876543210',
    'location': 'Coimbatore, Tamil Nadu',
    'joinedDate': DateTime(2023, 6, 15),
    'profileImage': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
    'membershipTier': 'Gold Member',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black87), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black87),
            onPressed: () {
              _showEditProfileDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header with Gradient
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFF8A65), // Light orange
                    Color(0xFFFF7043), // Main orange
                  ],
                ),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                child: Column(
                  children: [
                    // Profile Image with border
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(_userData['profileImage']),
                        child: _userData['profileImage'] == null ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Name
                    Text(_userData['name'], style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 6),

                    // Email
                    Text(_userData['email'], style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9))),

                    const SizedBox(height: 12),

                    // Membership Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text(_userData['membershipTier'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Stats Row with improved design
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem('Orders', '24'),
                          Container(height: 30, width: 1, color: Colors.white.withOpacity(0.3)),
                          _buildStatItem('Wishlist', '15'),
                          Container(height: 30, width: 1, color: Colors.white.withOpacity(0.3)),
                          _buildStatItem('Reviews', '8'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Profile Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildProfileCard('Personal Information', Icons.person_outline, [
                    _buildInfoRow(Icons.phone_outlined, 'Phone', _userData['phone']),
                    _buildInfoRow(Icons.location_on_outlined, 'Address', _userData['location']),
                    _buildInfoRow(
                      Icons.calendar_today_outlined,
                      'Member Since',
                      '${_userData['joinedDate'].day}/${_userData['joinedDate'].month}/${_userData['joinedDate'].year}',
                    ),
                  ]),

                  const SizedBox(height: 16),

                  _buildProfileCard('My Shopping', Icons.shopping_bag_outlined, [
                    _buildMenuRow(Icons.shopping_bag_outlined, 'My Orders', () {
                      // Navigate to orders
                    }),
                    _buildMenuRow(Icons.favorite_outline, 'Wishlist', () {
                      // Navigate to wishlist
                    }),
                    _buildMenuRow(Icons.local_shipping_outlined, 'Track Orders', () {
                      // Navigate to order tracking
                    }),
                    _buildMenuRow(Icons.star_outline, 'My Reviews', () {
                      // Navigate to reviews
                    }),
                  ]),

                  const SizedBox(height: 16),

                  _buildProfileCard('Account & Payments', Icons.account_balance_wallet_outlined, [
                    _buildMenuRow(Icons.location_city_outlined, 'Saved Addresses', () {
                      // Navigate to addresses
                    }),
                    _buildMenuRow(Icons.payment_outlined, 'Payment Methods', () {
                      // Navigate to payment methods
                    }),
                    _buildMenuRow(Icons.card_giftcard_outlined, 'Gift Cards & Coupons', () {
                      // Navigate to gift cards
                    }),
                    _buildMenuRow(Icons.account_balance_wallet_outlined, 'Wallet', () {
                      // Navigate to wallet
                    }),
                  ]),

                  const SizedBox(height: 16),

                  _buildProfileCard('Settings & Support', Icons.settings_outlined, [
                    _buildMenuRow(Icons.notifications_outlined, 'Notifications', () {
                      // Show notification settings
                    }),
                    _buildMenuRow(Icons.language_outlined, 'Language', () {
                      // Show language settings
                    }),
                    _buildMenuRow(Icons.help_outline, 'Help & Support', () {
                      // Show help
                    }),
                    _buildMenuRow(Icons.privacy_tip_outlined, 'Privacy Policy', () {
                      // Show privacy policy
                    }),
                    _buildMenuRow(Icons.info_outline, 'About Us', () {
                      // Show about
                    }),
                  ]),

                  const SizedBox(height: 20),

                  // Logout Button with gradient
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFF7043), Color(0xFFFF5722)]),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: const Color(0xFFFF7043).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _showLogoutDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8))),
      ],
    );
  }

  Widget _buildProfileCard(String title, IconData titleIcon, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFFFF7043).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(titleIcon, size: 20, color: const Color(0xFFFF7043)),
                ),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87)),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFFFF7043)),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500))),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87), textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuRow(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 22, color: const Color(0xFFFF7043)),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87))),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w600)),
            content: const Text('Edit profile functionality will be implemented here.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: Colors.grey[600]))),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7043),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w600)),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: Colors.grey[600]))),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Add logout functionality here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7043),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Logout', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }
}
