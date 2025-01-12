import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/project_model.dart';
import 'project_detail_screen.dart';

class ProjectListingScreen extends StatelessWidget {
  const ProjectListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final projects = appState.projects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the create project screen
          Navigator.pushNamed(context, '/create-project');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}