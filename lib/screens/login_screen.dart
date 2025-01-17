import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Added loading state

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) async {
    setState(() {
      _isLoading = true; // Start loading
    });

    final appState = Provider.of<AppState>(context, listen: false);
    final email = _emailController.text;
    final password = _passwordController.text;

    final user = await appState.login(email, password);
    setState(() {
      _isLoading = false; // Stop loading
    });

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed! Please check your credentials.')),
      );
    }
  }

  void _signInAsGuest(BuildContext context) async {
    setState(() {
      _isLoading = true; // Start loading
    });

    final appState = Provider.of<AppState>(context, listen: false);
    final user = await appState.signInAsGuest();
    setState(() {
      _isLoading = false; // Stop loading
    });

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Guest login failed!')),
      );
    }
  }

  void _navigateToCreateAccount(BuildContext context) {
    Navigator.pushNamed(context, '/create-profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Add the logo here
                Image.asset(
                  'assets/logo.png', // Path to your logo image
                  height: 150, // Adjust the height as needed
                  width: 150, // Adjust the width as needed
                ),
                const SizedBox(height: 16), // Add some space between the logo and the slogan
                // Add the slogan
                const Text(
                  'Project Mate',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 8), // Space between the app name and slogan
                const Text(
                  'Connect. Collaborate. Create.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 32), // Add more space before the form
                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.email, color: Colors.blueAccent),
                  ),
                ),
                const SizedBox(height: 16), // Space between fields
                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
                  ),
                ),
                const SizedBox(height: 24), // Space before the login button
                // Login button
                _isLoading
                    ? const CircularProgressIndicator() // Show loading indicator
                    : ElevatedButton(
                  onPressed: () => _login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16), // Space between buttons
                // Guest login button
                OutlinedButton(
                  onPressed: _isLoading ? null : () => _signInAsGuest(context), // Disable button when loading
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: Colors.blueAccent),
                  ),
                  child: const Text(
                    'Login as Guest',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
                const SizedBox(height: 16), // Space between buttons
                // Create account button
                TextButton(
                  onPressed: _isLoading ? null : () => _navigateToCreateAccount(context), // Disable button when loading
                  child: const Text(
                    'Create Account',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}