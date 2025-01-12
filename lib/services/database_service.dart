import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/project_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createProject({
    required String title,
    required String description,
    required List<String> skillsNeeded,
    required int numberOfCollaboratorsNeeded,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final newProject = ProjectModel(
        projectId: "",
        title: title,
        description: description,
        skillsNeeded: skillsNeeded,
        postedBy: user.uid,
        numberOfCollaboratorsNeeded: numberOfCollaboratorsNeeded,
      );

      DocumentReference docRef = await _firestore.collection('projects').add(newProject.toMap());
      await _firestore.collection('projects').doc(docRef.id).update({'projectId': docRef.id});
    }
  }

  Future<List<ProjectModel>> getAllProjects() async {
    List<ProjectModel> projectList = [];
    try {
      QuerySnapshot projectQuery = await _firestore.collection('projects').get();
      for (var projectDoc in projectQuery.docs) {
        final projectData = projectDoc.data() as Map<String, dynamic>;
        projectList.add(ProjectModel.fromMap(projectData, projectDoc.id));
      }
      return projectList;
    } catch (e) {
      print(e);
      return [];
    }
  }
}