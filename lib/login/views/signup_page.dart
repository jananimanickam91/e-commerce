import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green[100],
                image: DecorationImage(image: AssetImage("images/image3.png"), fit: BoxFit.contain),
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
                          const Text('SIGN UP', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                          const SizedBox(height: 16),
                          const InputField(label: 'Username', icon: Icons.person),
                          const InputField(label: 'E-mail', icon: Icons.email),
                          const InputField(label: 'Password', icon: Icons.lock, obscure: true),
                          const InputField(label: 'Confirm Password', icon: Icons.lock, obscure: true),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black54,
                              minimumSize: const Size.fromHeight(40),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('CREATE ACCOUNT', style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Already have an account? Login here", style: TextStyle(color: Colors.black)),
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
}

class InputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool obscure;

  const InputField({super.key, required this.label, required this.icon, this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        obscureText: obscure,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, color: Colors.black),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
