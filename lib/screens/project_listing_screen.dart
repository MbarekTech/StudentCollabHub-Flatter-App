import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/project_model.dart';
import 'bottom_nav_bar.dart';
import 'project_detail_screen.dart';
import 'app_styles.dart'; // Import common styles

class ProjectListingScreen extends StatefulWidget {
  const ProjectListingScreen({super.key});

  @override
  State<ProjectListingScreen> createState() => _ProjectListingScreenState();
}

class _ProjectListingScreenState extends State<ProjectListingScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProjectModel> _filteredProjects = [];
  bool _isLoading = true;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadProjects();
    _searchController.addListener(_filterProjects);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadProjects() async {
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.loadProjects();
    setState(() {
      _filteredProjects = appState.projects;
      _isLoading = false;
    });
  }

  void _filterProjects() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProjects = Provider.of<AppState>(context, listen: false)
          .projects
          .where((project) =>
      project.title.toLowerCase().contains(query) ||
          project.description.toLowerCase().contains(query) ||
          project.skillsNeeded.join(", ").toLowerCase().contains(query))
          .toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/favorites');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects', style: AppStyles.appBarTextStyle),
        backgroundColor: AppStyles.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/create-project');
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: _buildSearchBar(),
        ),
      ),
      body: Container(
        color: AppStyles.backgroundColor,
        child: _isLoading
            ? _buildLoadingSkeleton()
            : _filteredProjects.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          padding: AppStyles.defaultPadding,
          itemCount: _filteredProjects.length,
          itemBuilder: (context, index) {
            final project = _filteredProjects[index];
            return _buildProjectCard(context, project);
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, ProjectModel project) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectDetailScreen(projectId: project.projectId),
            ),
          );
        },
        child: Padding(
          padding: AppStyles.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.work, color: AppStyles.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    project.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                project.description,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: project.skillsNeeded.map((skill) {
                  return Chip(
                    label: Text(skill),
                    backgroundColor: AppStyles.primaryColor.withOpacity(0.1),
                    labelStyle: TextStyle(color: AppStyles.primaryColor),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'View Details',
                    style: TextStyle(
                      color: AppStyles.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16, color: AppStyles.primaryColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: AppStyles.defaultPadding,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search projects...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return ListView.builder(
      padding: AppStyles.defaultPadding,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: AppStyles.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 16,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No projects found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}