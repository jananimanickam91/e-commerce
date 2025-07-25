import 'package:flutter/material.dart';
import 'package:example_code/login/views/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  void _handleLogin() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter both username and password')));
      return;
    }

    if (username.isNotEmpty && password.isNotEmpty) {
      Navigator.pop(context, username);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid credentials')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green[100],
                image: const DecorationImage(image: AssetImage("images/image3.png"), fit: BoxFit.contain),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 360,
                      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                      decoration: BoxDecoration(color: Colors.green[100]?.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('LOGIN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                          const SizedBox(height: 16),
                          InputField(label: 'Username', icon: Icons.person, controller: _usernameController),
                          InputField(label: 'Password', icon: Icons.lock, obscure: true, controller: _passwordController),
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                              ),
                              const Text('Remember me', style: TextStyle(color: Colors.black)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black54,
                              minimumSize: const Size.fromHeight(40),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('LOGIN', style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(height: 12),
                          TextButton(onPressed: () {}, child: const Text('Forgot Username / Password?', style: TextStyle(color: Colors.black))),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()));
                            },
                            child: const Text("Don't have an account? Sign up here", style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -35,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.green[100]?.withValues(alpha: 0.8),
                        child: const Icon(Icons.person_3, size: 40, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class InputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool obscure;
  final TextEditingController? controller;

  const InputField({super.key, required this.label, required this.icon, this.obscure = false, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.green.shade400, width: 2)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
