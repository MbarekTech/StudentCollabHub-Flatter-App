import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/project_model.dart';
import 'app_styles.dart'; // Import common styles

class CreateProjectScreen extends StatefulWidget {
  final ProjectModel? project;

  const CreateProjectScreen({super.key, this.project});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _collaboratorsController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _titleController.text = widget.project!.title;
      _descriptionController.text = widget.project!.description;
      _skillsController.text = widget.project!.skillsNeeded.join(", ");
      _collaboratorsController.text = widget.project!.numberOfCollaboratorsNeeded.toString();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _skillsController.dispose();
    _collaboratorsController.dispose();
    super.dispose();
  }

  void _createOrUpdateProject(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final appState = Provider.of<AppState>(context, listen: false);
    final title = _titleController.text;
    final description = _descriptionController.text;
    final skills = _skillsController.text.split(',').map((e) => e.trim()).toList();
    final collaborators = int.tryParse(_collaboratorsController.text) ?? 1;

    if (title.isNotEmpty && description.isNotEmpty && skills.isNotEmpty) {
      try {
        if (widget.project == null) {
          await appState.createProject(
            title: title,
            description: description,
            skillsNeeded: skills,
            numberOfCollaboratorsNeeded: collaborators,
          );
        } else {
          await appState.updateProject(
            projectId: widget.project!.projectId,
            title: title,
            description: description,
            skillsNeeded: skills,
            numberOfCollaboratorsNeeded: collaborators,
          );
        }
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.project == null ? 'Create Project' : 'Edit Project',
          style: AppStyles.appBarTextStyle,
        ),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: Container(
        color: AppStyles.backgroundColor,
        child: Padding(
          padding: AppStyles.defaultPadding,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildInputField(
                  controller: _titleController,
                  labelText: 'Title',
                  hintText: 'Enter project title',
                  icon: Icons.title,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  hintText: 'Enter project description',
                  icon: Icons.description,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _skillsController,
                  labelText: 'Skills Needed (comma-separated)',
                  hintText: 'e.g., Flutter, Dart, UI/UX',
                  icon: Icons.work,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _collaboratorsController,
                  labelText: 'Number of Collaborators Needed',
                  hintText: 'Enter a number',
                  icon: Icons.people,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _isLoading ? null : () => _createOrUpdateProject(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryColor,
                    padding: AppStyles.buttonPadding,
                  ),
                  child: Text(
                    widget.project == null ? 'Create Project' : 'Update Project',
                    style: AppStyles.buttonTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable input field widget with icons
  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    String? hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: AppStyles.primaryColor),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }
}