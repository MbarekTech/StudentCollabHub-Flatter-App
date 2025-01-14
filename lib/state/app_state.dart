import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/user_model.dart';
import '../models/project_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

class AppState extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  List<ProjectModel> _projects = [];

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  List<ProjectModel> get projects => _projects;

  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  AppState() {
    _setupAuthStateListener();
    loadProjects();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setupAuthStateListener() {
    _authService.authChanges.listen((user) {
      if (user != null) {
        _currentUser = UserModel(
          uid: user.uid,
          username: user.email ?? "Unknown",
          email: user.email ?? "",
          name: "Mbarek Ben", // Default value
          major: "Computer Science", // Default value
          skills: ["Flutter", "Dart", "Firebase"], // Default value
          bio: "I love coding!", // Default value
        );
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  Future<void> loadProjects() async {
    _projects = await _databaseService.getAllProjects();
    notifyListeners();
  }

  Future<User?> login(String email, String password) async {
    setLoading(true);
    final user = await _authService.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
    setLoading(false);
    return user;
  }

  Future<User?> signInAsGuest() async {
    setLoading(true);
    final user = await _authService.signInAnonymously();
    if (user != null) {
      await loadProjects();
    }
    setLoading(false);
    return user;
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<User?> createUser({
    required String email,
    required String password,
    required String username,
    required String name,
    required String major,
    required List<String> skills,
    required String bio,
  }) async {
    try {
      final userCredential = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential != null) {
        _currentUser = UserModel(
          uid: userCredential.uid,
          username: username,
          email: email,
          name: name,
          major: major,
          skills: skills,
          bio: bio,
        );
        notifyListeners();
        return userCredential;
      }
      return null;
    } catch (e) {
      print("Error creating user: $e");
      return null;
    }
  }

  Future<void> createProject({
    required String title,
    required String description,
    required List<String> skillsNeeded,
    required int numberOfCollaboratorsNeeded,
  }) async {
    try {
      await _databaseService.createProject(
        title: title,
        description: description,
        skillsNeeded: skillsNeeded,
        numberOfCollaboratorsNeeded: numberOfCollaboratorsNeeded,
      );
      await loadProjects(); // Refresh the project list
    } catch (e) {
      print("Error creating project: $e");
    }
  }

  Future<void> updateProject({
    required String projectId,
    required String title,
    required String description,
    required List<String> skillsNeeded,
    required int numberOfCollaboratorsNeeded,
  }) async {
    try {
      await _databaseService.updateProject(
        projectId: projectId,
        title: title,
        description: description,
        skillsNeeded: skillsNeeded,
        numberOfCollaboratorsNeeded: numberOfCollaboratorsNeeded,
      );
      await loadProjects(); // Refresh the project list
    } catch (e) {
      print("Error updating project: $e");
    }
  }

  Future<void> deleteProject({required String projectId}) async {
    try {
      await _databaseService.deleteProject(projectId: projectId);
      await loadProjects(); // Refresh the project list
    } catch (e) {
      print("Error deleting project: $e");
    }
  }

  Future<void> sendMessage({
    required String receiverId,
    required String text,
  }) async {
    try {
      await _databaseService.sendMessage(
        receiverId: receiverId,
        text: text,
      );
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Stream<QuerySnapshot> getMessagesStream({required String receiverId}) {
    return _databaseService.getMessagesStream(receiverId: receiverId);
  }

  Future<void> addCollaborator({
    required String projectId,
    required String userId,
  }) async {
    try {
      await _databaseService.addCollaborator(
        projectId: projectId,
        userId: userId,
      );
      await loadProjects(); // Refresh the project list
    } catch (e) {
      print("Error adding collaborator: $e");
    }
  }

  Future<void> removeCollaborator({
    required String projectId,
    required String userId,
  }) async {
    try {
      await _databaseService.removeCollaborator(
        projectId: projectId,
        userId: userId,
      );
      await loadProjects(); // Refresh the project list
    } catch (e) {
      print("Error removing collaborator: $e");
    }
  }

  Future<void> updateUserProfile({
    required String username,
    required String email,
    required String? name,
    required String? major,
    required List<String>? skills,
    required String? bio,
    required bool receiveNotifications,
  }) async {
    try {
      final user = _authService.getCurrentUser();
      if (user != null) {
        await _databaseService.updateUserProfile(
          uid: user.uid,
          username: username,
          email: email,
          name: name,
          major: major,
          skills: skills,
          bio: bio,
          receiveNotifications: receiveNotifications,
        );
        // Update the current user in the app state
        _currentUser = UserModel(
          uid: user.uid,
          username: username,
          email: email,
          name: name,
          major: major,
          skills: skills,
          bio: bio,
          receiveNotifications: receiveNotifications,
        );
        notifyListeners();
      }
    } catch (e) {
      print("Error updating user profile: $e");
    }
  }
}