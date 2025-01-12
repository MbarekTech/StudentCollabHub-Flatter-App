import 'package:flutter/material.dart';
import '../models/project_model.dart';

class ProjectDetailScreen extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ),
    );
  }
}