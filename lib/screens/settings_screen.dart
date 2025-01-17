import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'login_screen.dart';
import 'bottom_nav_bar.dart'; // Import the BottomNavBar

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 3; // Set the index for Settings screen

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding screen
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/projects');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/favorites');
        break;
      case 3:
      // Already on the Settings screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currentUser = appState.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              if (currentUser != null) ...[


                // Change Password
                Card(
                  elevation: 2,
                  child: ListTile(
                    title: const Text('Change Password'),
                    subtitle: const Text('Update your account password'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showChangePasswordDialog(context);
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Logout
                Card(
                  elevation: 2,
                  child: ListTile(
                    title: const Text('Logout'),
                    subtitle: const Text('Sign out of your account'),
                    trailing: const Icon(Icons.logout, color: Colors.red),
                    onTap: () async {
                      await appState.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ),
              ] else ...[
                const Center(child: Text('No user data available')),
              ],
            ],
          ),
        ),
      ),
      // Add the bottom navigation bar
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController _currentPasswordController = TextEditingController();
    final TextEditingController _newPasswordController = TextEditingController();
    final TextEditingController _confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final appState = Provider.of<AppState>(context, listen: false);
                final currentPassword = _currentPasswordController.text.trim();
                final newPassword = _newPasswordController.text.trim();
                final confirmPassword = _confirmPasswordController.text.trim();

                if (newPassword != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('New passwords do not match')),
                  );
                  return;
                }

                try {
                  await appState.changePassword(
                    currentPassword: currentPassword,
                    newPassword: newPassword,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password changed successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to change password: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}