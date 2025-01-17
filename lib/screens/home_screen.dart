import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected index for the bottom navigation bar

  // Function to handle navigation bar item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding screen based on the selected index
    switch (index) {
      case 0:
      // Home screen is already open
        break;
      case 1:
        Navigator.pushNamed(context, '/projects');
        break;
      case 2:
        Navigator.pushNamed(context, '/favorites');
        break;
      case 3:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add the logo here
              Center(
                child: Image.asset(
                  'assets/logo.png', // Path to your logo image
                  height: 100, // Adjust the height as needed
                  width: 100, // Adjust the width as needed
                ),
              ),
              const SizedBox(height: 16), // Space between the logo and the welcome message
              if (user != null)
                Text(
                  'Welcome, ${user.email}!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              const SizedBox(height: 16),
              const Text(
                'What would you like to do today?',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  children: [
                    _buildActionCard(
                      context,
                      icon: Icons.person,
                      label: 'View Profile',
                      color: Colors.blueAccent,
                      onPressed: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.work,
                      label: 'View Projects',
                      color: Colors.green,
                      onPressed: () {
                        Navigator.pushNamed(context, '/projects');
                      },
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.add,
                      label: 'Create Project',
                      color: Colors.orange,
                      onPressed: () {
                        Navigator.pushNamed(context, '/create-project');
                      },
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.favorite,
                      label: 'View Favorites',
                      color: Colors.purple,
                      onPressed: () {
                        Navigator.pushNamed(context, '/favorites');
                      },
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.people,
                      label: 'View Users',
                      color: Colors.teal,
                      onPressed: () {
                        Navigator.pushNamed(context, '/users');
                      },
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.message,
                      label: 'Messages',
                      color: Colors.teal,
                      onPressed: () {
                        Navigator.pushNamed(context, '/messages');
                      },
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.settings,
                      label: 'Settings',
                      color: Colors.blueGrey,
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Add the bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensure all items are visible
        currentIndex: _selectedIndex, // Highlight the selected item
        onTap: _onItemTapped, // Handle item selection
        selectedItemColor: Colors.blueAccent, // Color for the selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onPressed,
      }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}