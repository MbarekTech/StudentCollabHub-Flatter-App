import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/project_model.dart';
import 'project_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final favoriteProjects = appState.projects
        .where((project) => appState.currentUser?.favoriteProjects.contains(project.projectId) ?? false)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple, // Different color for favorites
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: favoriteProjects.length,
          itemBuilder: (context, index) {
            final project = favoriteProjects[index];
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