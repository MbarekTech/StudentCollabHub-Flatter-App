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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final email = _emailController.text;
    final password = _passwordController.text;

    final user = await appState.login(email, password);
    if (user != null) {
      // Navigate to the home screen
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Show error message (to be implemented later)
      print("Login failed!");
    }
  }

  void _signInAsGuest(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final user = await appState.signInAsGuest();
    if (user != null) {
      // Navigate to the home screen
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Show error message (to be implemented later)
      print("Guest login failed!");
    }
  }

  void _navigateToCreateAccount(BuildContext context) {
    // Navigate to the create account screen
    Navigator.pushNamed(context, '/create-profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _login(context),
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => _signInAsGuest(context),
              child: const Text('Login as Guest'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _navigateToCreateAccount(context),
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}