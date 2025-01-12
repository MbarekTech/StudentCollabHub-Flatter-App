import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/project_model.dart';
import 'project_detail_screen.dart';

class ProjectListingScreen extends StatefulWidget {
  const ProjectListingScreen({super.key});

  @override
  State<ProjectListingScreen> createState() => _ProjectListingScreenState();
}

class _ProjectListingScreenState extends State<ProjectListingScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProjectModel> _filteredProjects = [];

  @override
  void initState() {
    super.initState();
    _filteredProjects = Provider.of<AppState>(context, listen: false).projects;
    _searchController.addListener(_filterProjects);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to the create project screen
              Navigator.pushNamed(context, '/create-project');
            },
            icon: const Icon(Icons.add),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredProjects.length,
        itemBuilder: (context, index) {
          final project = _filteredProjects[index];
          return ListTile(
            title: Text(project.title),
            subtitle: Text(project.description),
            onTap: () {
              // Navigate to the project detail screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectDetailScreen(project: project),
                ),
              );
            },
          );
        },
      ),
    );
  }
}