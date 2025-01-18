import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'bottom_nav_bar.dart';
import 'app_styles.dart'; // Import the common styles

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _receiveNotifications = true;
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

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
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    final user = appState.currentUser;
    if (user != null) {
      _usernameController.text = user.username;
      _emailController.text = user.email;
      _nameController.text = user.name ?? '';
      _majorController.text = user.major ?? '';
      _skillsController.text = user.skills?.join(", ") ?? '';
      _bioController.text = user.bio ?? '';
      _receiveNotifications = user.receiveNotifications;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _majorController.dispose();
    _skillsController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _updateProfile(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.updateUserProfile(
      username: _usernameController.text,
      email: _emailController.text,
      name: _nameController.text.isEmpty ? null : _nameController.text,
      major: _majorController.text.isEmpty ? null : _majorController.text,
      skills: _skillsController.text.isEmpty ? null : _skillsController.text.split(',').map((e) => e.trim()).toList(),
      bio: _bioController.text.isEmpty ? null : _bioController.text,
      receiveNotifications: _receiveNotifications,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile', style: AppStyles.appBarTextStyle),
        backgroundColor: AppStyles.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppStyles.textColor),
      ),
      body: Container(
        color: AppStyles.backgroundColor,
        child: Padding(
          padding: AppStyles.defaultPadding,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildInputField(
                  controller: _usernameController,
                  labelText: 'Username',
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _emailController,
                  labelText: 'Email',
                  icon: Icons.email,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _nameController,
                  labelText: 'Name',
                  icon: Icons.badge,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _majorController,
                  labelText: 'Major',
                  icon: Icons.school,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _skillsController,
                  labelText: 'Skills (comma-separated)',
                  icon: Icons.work,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _bioController,
                  labelText: 'Bio',
                  icon: Icons.description,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                /*Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SwitchListTile(
                    title: const Text(
                      'Receive Notifications',
                      style: TextStyle(fontSize: 16),
                    ),
                    value: _receiveNotifications,
                    onChanged: (value) {
                      setState(() {
                        _receiveNotifications = value;
                      });
                    },
                  ),
                ),*/
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _updateProfile(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryColor,
                    padding: AppStyles.buttonPadding,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Profile',
                    style: AppStyles.buttonTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: AppStyles.inputDecoration(labelText: labelText, icon: icon),
      maxLines: maxLines,
    );
  }
}