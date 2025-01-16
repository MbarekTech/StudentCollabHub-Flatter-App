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
        title: const Text('Projects', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/create-project');
            },
            icon: const Icon(Icons.add, color: Colors.white),
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
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: _filteredProjects.length,
          itemBuilder: (context, index) {
            final project = _filteredProjects[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(project.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(project.description),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectDetailScreen(projectId: project.projectId),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}