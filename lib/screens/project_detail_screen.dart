import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../state/app_state.dart';
import '../models/project_model.dart';
import 'create_project_screen.dart';
import 'message_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  void _editProject(BuildContext context, ProjectModel project) async {
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
    await appState.deleteProject(projectId: projectId);
    // Navigate back to the project listing screen
    Navigator.pop(context);
  }

  void _joinProject(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final currentUser = appState.currentUser;
    if (currentUser != null) {
      await appState.addCollaborator(
        projectId: projectId,
        userId: currentUser.uid,
      );
    }
  }

  void _leaveProject(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final currentUser = appState.currentUser;
    if (currentUser != null) {
      await appState.removeCollaborator(
        projectId: projectId,
        userId: currentUser.uid,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currentUser = appState.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('projects')
            .doc(projectId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Project not found'));
          }

          final projectData = snapshot.data!.data() as Map<String, dynamic>;
          final project = ProjectModel.fromMap(projectData, projectId);

          final isCollaborator =
              currentUser != null && project.collaborators.contains(currentUser.uid);

          return Padding(
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
                const SizedBox(height: 16),
                Text('Collaborators: ${project.collaborators.length}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 24),
                if (currentUser != null && currentUser.uid == project.postedBy) ...[
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _editProject(context, project),
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
                if (currentUser != null && currentUser.uid != project.postedBy) ...[
                  Center(
                    child: ElevatedButton(
                      onPressed: isCollaborator ? () => _leaveProject(context) : () => _joinProject(context),
                      child: Text(isCollaborator ? 'Leave Project' : 'Join Project'),
                    ),
                  ),
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
              ],
            ),
          );
        },
      ),
    );
  }
}