import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'app_styles.dart'; // Import common styles

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isLoading = false;

  final List<String> _routes = [
    '/home',
    '/projects',
    '/favorites',
    '/settings',
  ];

  final List<Map<String, dynamic>> _actions = [
    {
      'icon': Icons.person,
      'label': 'View Profile',
      'color': Colors.blueAccent,
      'route': '/profile',
    },
    {
      'icon': Icons.work,
      'label': 'View Projects',
      'color': Colors.green,
      'route': '/projects',
    },
    {
      'icon': Icons.add,
      'label': 'Create Project',
      'color': Colors.orange,
      'route': '/create-project',
    },
    {
      'icon': Icons.favorite,
      'label': 'View Favorites',
      'color': Colors.purple,
      'route': '/favorites',
    },
    {
      'icon': Icons.people,
      'label': 'View Users',
      'color': Colors.teal,
      'route': '/users',
    },
    {
      'icon': Icons.message,
      'label': 'Messages',
      'color': Colors.teal,
      'route': '/messages',
    },
    {
      'icon': Icons.settings,
      'label': 'Settings',
      'color': Colors.blueGrey,
      'route': '/settings',
    },
  ];

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    try {
      await Navigator.pushNamed(context, _routes[index]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigation error: $e')),
      );
    }
  }

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final appState = Provider.of<AppState>(context, listen: false);
      await appState.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-out error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.currentUser;
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: AppStyles.appBarTextStyle),
        backgroundColor: AppStyles.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: Semantics(
              label: 'Sign out',
              child: const Icon(Icons.logout, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        color: AppStyles.backgroundColor,
        child: Padding(
          padding: AppStyles.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 16),
              if (user != null)
                Text(
                  'Welcome, ${user.name}!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              const SizedBox(height: 16),
              const Text(
                'What would you like to do today?',
                style: AppStyles.subtitleTextStyle,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  children: _actions.map((action) {
                    return ActionCard(
                      icon: action['icon'],
                      label: action['label'],
                      color: action['color'],
                      onPressed: () {
                        Navigator.pushNamed(context, action['route']);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppStyles.primaryColor,
        unselectedItemColor: Colors.grey,
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
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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
              Icon(icon, size: 48, color: color),
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