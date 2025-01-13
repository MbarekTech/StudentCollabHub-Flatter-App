import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/project_model.dart';
import 'create_project_screen.dart';
import 'message_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailScreen({super.key, required this.project});

  void _editProject(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateProjectScreen(
          project: project,
        ),
      ),
    );

    if (result == true) {
      // Refresh the project list after editing
      await appState.loadProjects();
    }
  }

  void _deleteProject(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.deleteProject(projectId: project.projectId);
    // Navigate back to the project listing screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currentUser = appState.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${project.title}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Text('Description: ${project.description}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Text('Skills Needed: ${project.skillsNeeded.join(", ")}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Text('Collaborators Needed: ${project.numberOfCollaboratorsNeeded}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            if (currentUser != null && currentUser.uid == project.postedBy) ...[
              Center(
                child: ElevatedButton(
                  onPressed: () => _editProject(context),
                  child: const Text('Edit Project'),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () => _deleteProject(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Delete Project'),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the message screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessageScreen(receiverId: project.postedBy),
                    ),
                  );
                },
                child: const Text('Message Creator'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}