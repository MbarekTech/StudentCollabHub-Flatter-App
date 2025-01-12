import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _collaboratorsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _skillsController.dispose();
    _collaboratorsController.dispose();
    super.dispose();
  }

  void _createProject(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final title = _titleController.text;
    final description = _descriptionController.text;
    final skills = _skillsController.text.split(',').map((e) => e.trim()).toList();
    final collaborators = int.tryParse(_collaboratorsController.text) ?? 1;

    if (title.isNotEmpty && description.isNotEmpty && skills.isNotEmpty) {
      await appState.createProject(
        title: title,
        description: description,
        skillsNeeded: skills,
        numberOfCollaboratorsNeeded: collaborators,
      );
      // Navigate back to the home screen
      Navigator.pop(context);
    } else {
      // Show error message (to be implemented later)
      print("Please fill in all fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Project'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _skillsController,
                decoration: const InputDecoration(
                  labelText: 'Skills Needed (comma-separated)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _collaboratorsController,
                decoration: const InputDecoration(
                  labelText: 'Number of Collaborators Needed',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _createProject(context),
                child: const Text('Create Project'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}