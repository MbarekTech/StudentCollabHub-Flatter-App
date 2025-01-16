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
      await appState.loadProjects();
    }
  }

  void _deleteProject(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.deleteProject(projectId: projectId);
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
    final isFavorited = appState.isProjectFavorited(projectId); // Check if project is favorited

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
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
                Text('Title: ${project.title}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('Description: ${project.description}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Text('Skills Needed: ${project.skillsNeeded.join(", ")}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Text('Collaborators Needed: ${project.numberOfCollaboratorsNeeded}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Text('Collaborators: ${project.collaborators.length}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24),
                if (currentUser != null) ...[
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (isFavorited) {
                          appState.removeFavoriteProject(projectId);
                        } else {
                          appState.addFavoriteProject(projectId);
                        }
                      },
                      icon: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                      ), // Favorite icon
                      label: Text(
                        isFavorited ? 'Remove from Favorites' : 'Add to Favorites',
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFavorited ? Colors.red : Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (currentUser != null && currentUser.uid == project.postedBy) ...[
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _editProject(context, project),
                      icon: const Icon(Icons.edit, color: Colors.white), // Edit icon
                      label: const Text('Edit Project', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _deleteProject(context),
                      icon: const Icon(Icons.delete, color: Colors.white), // Delete icon
                      label: const Text('Delete Project', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                    ),
                  ),
                ],
                if (currentUser != null && currentUser.uid != project.postedBy) ...[
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: isCollaborator ? () => _leaveProject(context) : () => _joinProject(context),
                      icon: Icon(
                        isCollaborator ? Icons.exit_to_app : Icons.group_add,
                        color: Colors.white,
                      ), // Join/Leave icon
                      label: Text(
                        isCollaborator ? 'Leave Project' : 'Join Project',
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCollaborator ? Colors.red : Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessageScreen(receiverId: project.postedBy),
                          ),
                        );
                      },
                      icon: const Icon(Icons.message, color: Colors.white), // Message icon
                      label: const Text('Message Creator', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
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