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

  // In home_screen.dart, add a new action in the _actions list:
  final List<Map<String, dynamic>> _actions = [
    {
      'icon': Icons.person,
      'label': 'My Profile',
      'color': Colors.blueAccent,
      'route': '/profile',
    },
    {
      'icon': Icons.assignment,
      'label': 'My Projects',
      'color': Colors.orange,
      'route': '/my-projects',
    },
    {
      'icon': Icons.work,
      'label': 'All Projects',
      'color': Colors.green,
      'route': '/projects',
    },
    {
      'icon': Icons.favorite,
      'label': 'Favorites',
      'color': Colors.purple,
      'route': '/favorites',
    },
    {
      'icon': Icons.people,
      'label': 'All Users',
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (user != null)
                          Text(
                            '${user.name}!',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        const SizedBox(height: 8),
                        const Text(
                          'What would you like to do today?',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16), // Add spacing between text and logo
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(24),


                    ),
                    child: Image.asset(
                      'assets/logo.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24), // Add spacing below the row
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-project');
        },
        backgroundColor: AppStyles.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: AppStyles.primaryColor,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
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
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
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
      ),
    );
  }
}