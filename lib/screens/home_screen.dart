import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: () async {
              await appState.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (user != null)
                Text(
                  'Welcome, ${user.email}!',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 16),
              const Text(
                'This is the home screen.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('View Profile', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/projects');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('View Projects', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/create-project');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Create Project', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}