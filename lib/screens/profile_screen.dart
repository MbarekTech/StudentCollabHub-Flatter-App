import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null) ...[
              Text('Username: ${user.username}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              Text('Email: ${user.email}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              Text('Name: ${user.name ?? "Not provided"}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              Text('Major: ${user.major ?? "Not provided"}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              Text('Skills: ${user.skills?.join(", ") ?? "Not provided"}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              Text('Bio: ${user.bio ?? "Not provided"}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the edit profile screen (to be implemented later)
                    print("Navigate to edit profile screen");
                  },
                  child: const Text('Edit Profile'),
                ),
              ),
            ] else ...[
              const Center(child: Text('No user data available')),
            ],
          ],
        ),
      ),
    );
  }
}