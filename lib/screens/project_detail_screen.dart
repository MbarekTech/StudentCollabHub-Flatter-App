import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../state/app_state.dart';
import '../models/project_model.dart';
import 'create_project_screen.dart';
import 'message_screen.dart';
import 'bottom_nav_bar.dart'; // Import the BottomNavBar

class ProjectDetailScreen extends StatefulWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  int _selectedIndex = 1; // Set the index for Project Detail screen (or adjust as needed)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding screen
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/projects');
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
    final appState = Provider.of<AppState>(context);
    final currentUser = appState.currentUser;
    final isFavorited = appState.isProjectFavorited(widget.projectId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('projects')
            .doc(widget.projectId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Project not found'));
          }

          final projectData = snapshot.data!.data() as Map<String, dynamic>;
          final project = ProjectModel.fromMap(projectData, widget.projectId);

          final isCollaborator =
              currentUser != null && project.collaborators.contains(currentUser.uid);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project Details Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.work, color: Colors.blueAccent, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              project.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          project.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.construction, color: Colors.blueAccent, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Skills Needed: ${project.skillsNeeded.join(", ")}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.people, color: Colors.blueAccent, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Collaborators Needed: ${project.numberOfCollaboratorsNeeded}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.group, color: Colors.blueAccent, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Collaborators: ${project.collaborators.length}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Collaborators Section
                if (project.collaborators.isNotEmpty) ...[
                  const Text(
                    'Collaborators:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: project.collaborators.length,
                      itemBuilder: (context, index) {
                        final collaboratorId = project.collaborators[index];
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(collaboratorId)
                              .get(),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return const ListTile(
                                title: Text('Loading...'),
                              );
                            }

                            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                              return const ListTile(
                                title: Text('Unknown User'),
                              );
                            }

                            final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                            final username = userData['username'] ?? 'Unknown';

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: Text(
                                  username[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                username,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: currentUser?.uid == project.postedBy
                                  ? IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () => _removeCollaborator(context, collaboratorId),
                              )
                                  : null,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Action Buttons
                if (currentUser != null) ...[
                  _buildActionButton(
                    icon: isFavorited ? Icons.favorite : Icons.favorite_border,
                    label: isFavorited ? 'Remove from Favorites' : 'Add to Favorites',
                    color: isFavorited ? Colors.red : Colors.blueAccent,
                    onPressed: () {
                      if (isFavorited) {
                        appState.removeFavoriteProject(widget.projectId);
                      } else {
                        appState.addFavoriteProject(widget.projectId);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                if (currentUser != null && currentUser.uid == project.postedBy) ...[
                  _buildActionButton(
                    icon: Icons.edit,
                    label: 'Edit Project',
                    color: Colors.blueAccent,
                    onPressed: () => _editProject(context, project),
                  ),
                  const SizedBox(height: 16),
                  _buildActionButton(
                    icon: Icons.delete,
                    label: 'Delete Project',
                    color: Colors.red,
                    onPressed: () => _deleteProject(context),
                  ),
                ],
                if (currentUser != null && currentUser.uid != project.postedBy) ...[
                  _buildActionButton(
                    icon: isCollaborator ? Icons.exit_to_app : Icons.group_add,
                    label: isCollaborator ? 'Leave Project' : 'Join Project',
                    color: isCollaborator ? Colors.red : Colors.blueAccent,
                    onPressed: isCollaborator ? () => _leaveProject(context) : () => _joinProject(context),
                  ),
                  const SizedBox(height: 16),
                  _buildActionButton(
                    icon: Icons.message,
                    label: 'Message Creator',
                    color: Colors.green,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessageScreen(receiverId: project.postedBy),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
      // Add the bottom navigation bar
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white),
          label: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  void _editProject(BuildContext context, ProjectModel project) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateProjectScreen(project: project),
      ),
    );

    if (result == true) {
      await appState.loadProjects();
    }
  }

  void _deleteProject(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.deleteProject(projectId: widget.projectId);
    Navigator.pop(context);
  }

  void _joinProject(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final currentUser = appState.currentUser;
    if (currentUser != null) {
      await appState.addCollaborator(
        projectId: widget.projectId,
        userId: currentUser.uid,
      );
    }
  }

  void _leaveProject(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final currentUser = appState.currentUser;
    if (currentUser != null) {
      await appState.removeCollaborator(
        projectId: widget.projectId,
        userId: currentUser.uid,
      );
    }
  }

  void _removeCollaborator(BuildContext context, String userId) async {
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.removeCollaborator(
      projectId: widget.projectId,
      userId: userId,
    );
  }
}