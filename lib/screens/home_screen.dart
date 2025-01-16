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
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                icon: const Icon(Icons.person, color: Colors.white), // Profile icon
                label: const Text('View Profile', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/projects');
                },
                icon: const Icon(Icons.work, color: Colors.white), // Projects icon
                label: const Text('View Projects', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/create-project');
                },
                icon: const Icon(Icons.add, color: Colors.white), // Create project icon
                label: const Text('Create Project', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/favorites');
                },
                icon: const Icon(Icons.favorite, color: Colors.white), // Favorites icon
                label: const Text('View Favorites', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}