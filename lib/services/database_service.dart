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


  Future<void> updateProject({
    required String projectId,
    required String title,
    required String description,
    required List<String> skillsNeeded,
    required int numberOfCollaboratorsNeeded,
  }) async {
    await _firestore.collection('projects').doc(projectId).update({
      'title': title,
      'description': description,
      'skillsNeeded': skillsNeeded,
      'numberOfCollaboratorsNeeded': numberOfCollaboratorsNeeded,
    });
  }

  Future<void> deleteProject({required String projectId}) async {
    await _firestore.collection('projects').doc(projectId).delete();
  }

  Future<void> sendMessage({
    required String receiverId,
    required String text,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final message = {
        'text': text,
        'senderId': user.uid,
        'receiverId': receiverId,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Create a unique chat ID between the two users
      final chatId = user.uid.compareTo(receiverId) > 0
          ? '${user.uid}_$receiverId'
          : '${receiverId}_${user.uid}';

      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(message);
    }
  }

  Stream<QuerySnapshot> getMessagesStream({required String receiverId}) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Create a unique chat ID between the two users
      final chatId = user.uid.compareTo(receiverId) > 0
          ? '${user.uid}_$receiverId'
          : '${receiverId}_${user.uid}';

      return _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots();
    }
    return const Stream.empty();
  }

  Future<void> addCollaborator({
    required String projectId,
    required String userId,
  }) async {
    await _firestore.collection('projects').doc(projectId).update({
      'collaborators': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> removeCollaborator({
    required String projectId,
    required String userId,
  }) async {
    await _firestore.collection('projects').doc(projectId).update({
      'collaborators': FieldValue.arrayRemove([userId]),
    });
  }
  Future<void> updateUserProfile({
    required String uid,
    required String username,
    required String email,
    required String? name,
    required String? major,
    required List<String>? skills,
    required String? bio,
    required bool receiveNotifications,
  }) async {
    await _firestore.collection('users').doc(uid).update({
      'username': username,
      'email': email,
      'name': name,
      'major': major,
      'skills': skills,
      'bio': bio,
      'receiveNotifications': receiveNotifications,
    });
  }
}