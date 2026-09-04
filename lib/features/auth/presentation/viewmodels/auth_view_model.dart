/// **Architecture Layer**: Presentation (ViewModel)
/// **Purpose**: Manages state and authentication flows (Google, Apple, Email/Password, and Incognito Guest Mode).

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reestoko/core/utils/app_logger.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  bool get isGuest => currentUser?.isAnonymous ?? true;
  bool get isAuthenticated => currentUser != null;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AuthViewModel() {
    _auth.authStateChanges().listen((user) {
      notifyListeners();
    });
  }

  /// Sign In Incognito (Guest Mode)
  Future<bool> signInIncognito() async {
    _setLoading(true);
    try {
      final credentials = await _auth.signInAnonymously();
      AppLogger.i('Guest Incognito Login successful: ${credentials.user?.uid}');
      _setLoading(false);
      return true;
    } catch (e) {
      _handleError('Guest Incognito Login failed: $e');
      return false;
    }
  }

  /// Sign In / Register with Email & Password
  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      final credentials = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      AppLogger.i('Email Login successful: ${credentials.user?.email}');
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _handleError(e.message ?? 'Authentication failed');
      return false;
    } catch (e) {
      _handleError('Email login error: $e');
      return false;
    }
  }

  /// Register with Email & Password
  Future<bool> registerWithEmail(String email, String password, String name) async {
    _setLoading(true);
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await credentials.user?.updateDisplayName(name.trim());
      AppLogger.i('Email Registration successful: ${credentials.user?.email}');
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _handleError(e.message ?? 'Registration failed');
      return false;
    } catch (e) {
      _handleError('Registration error: $e');
      return false;
    }
  }

  /// Google Sign In Integration
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    try {
      final googleProvider = GoogleAuthProvider();
      final userCredential = await _auth.signInWithProvider(googleProvider);
      AppLogger.i('Google Sign In successful: ${userCredential.user?.email}');
      _setLoading(false);
      return true;
    } catch (e) {
      _handleError('Google Sign In failed: $e');
      return false;
    }
  }

  /// Apple Sign In Integration (OAuth Trigger)
  Future<bool> signInWithApple() async {
    _setLoading(true);
    try {
      final appleProvider = AppleAuthProvider();
      final userCredential = await _auth.signInWithProvider(appleProvider);
      AppLogger.i('Apple Sign In successful: ${userCredential.user?.email}');
      _setLoading(false);
      return true;
    } catch (e) {
      _handleError('Apple Sign In failed: $e');
      return false;
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _errorMessage = null;
    notifyListeners();
  }

  void _handleError(String message) {
    _isLoading = false;
    _errorMessage = message;
    AppLogger.e(message);
    notifyListeners();
  }
}
