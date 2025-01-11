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
        _currentUser = UserModel(
          uid: user.uid,
          username: user.email ?? "Unknown",
          email: user.email ?? "",
        );
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    setLoading(true);
    final user = await _authService.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
    setLoading(false);
    return user;
  }

  Future<void> signInAsGuest() async {
    setLoading(true);
    final user = await _authService.signInAnonymously();
    setLoading(false);
    return user;
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}