class ProjectModel {
  final String projectId;
  final String title;
  final String description;
  final List<String> skillsNeeded;
  final String postedBy;
  final int numberOfCollaboratorsNeeded;
  final List<String> collaborators;

  ProjectModel({
    required this.projectId,
    required this.title,
    required this.description,
    required this.skillsNeeded,
    required this.postedBy,
    required this.numberOfCollaboratorsNeeded,
    this.collaborators = const [],
  });

  factory ProjectModel.fromMap(Map<String, dynamic> map, String projectId) {
    return ProjectModel(
      projectId: projectId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      skillsNeeded: List<String>.from(map['skillsNeeded'] ?? []),
      postedBy: map['postedBy'] ?? '',
      numberOfCollaboratorsNeeded: map['numberOfCollaboratorsNeeded'] ?? 1,
      collaborators: List<String>.from(map['collaborators'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'skillsNeeded': skillsNeeded,
      'postedBy': postedBy,
      'numberOfCollaboratorsNeeded': numberOfCollaboratorsNeeded,
      'collaborators': collaborators,
    };
  }
}
