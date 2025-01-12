import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AppState extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  final AuthService _authService = AuthService();

  AppState() {
    _setupAuthStateListener();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setupAuthStateListener() {
    _authService.authChanges.listen((user) {
      if (user != null) {
        // Simulate loading user profile data
        _currentUser = UserModel(
          uid: user.uid,
          username: user.email ?? "Unknown",
          email: user.email ?? "",
          name: "John Doe", // Default value
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
}