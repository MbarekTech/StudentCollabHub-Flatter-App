import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'edit_profile_screen.dart';
import 'app_styles.dart'; // Import the common styles

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: AppStyles.appBarTextStyle),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: Container(
        color: AppStyles.backgroundColor,
        child: Padding(
          padding: AppStyles.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user != null) ...[
                _buildProfileDetail(
                  icon: Icons.person,
                  label: 'Username',
                  value: user.username,
                ),
                const SizedBox(height: 16),
                _buildProfileDetail(
                  icon: Icons.email,
                  label: 'Email',
                  value: user.email,
                ),
                const SizedBox(height: 16),
                _buildProfileDetail(
                  icon: Icons.badge,
                  label: 'Name',
                  value: user.name ?? "Not provided",
                ),
                const SizedBox(height: 16),
                _buildProfileDetail(
                  icon: Icons.school,
                  label: 'Major',
                  value: user.major ?? "Not provided",
                ),
                const SizedBox(height: 16),
                _buildProfileDetail(
                  icon: Icons.work,
                  label: 'Skills',
                  value: user.skills?.join(", ") ?? "Not provided",
                ),
                const SizedBox(height: 16),
                _buildProfileDetail(
                  icon: Icons.description,
                  label: 'Bio',
                  value: user.bio ?? "Not provided",
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.primaryColor,
                      padding: AppStyles.buttonPadding,
                    ),
                    child: const Text('Edit Profile', style: AppStyles.buttonTextStyle),
                  ),
                ),
              ] else ...[
                const Center(child: Text('No user data available')),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build profile details with icons
  Widget _buildProfileDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppStyles.primaryColor, size: 24),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppStyles.profileTextStyle,
            ),
          ],
        ),
      ],
    );
  }
}