import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

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
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _majorController,
                  decoration: const InputDecoration(
                    labelText: 'Major',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _skillsController,
                  decoration: const InputDecoration(
                    labelText: 'Skills (comma-separated)',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Receive Notifications'),
                  value: _receiveNotifications,
                  onChanged: (value) {
                    setState(() {
                      _receiveNotifications = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _updateProfile(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text('Save Profile', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}