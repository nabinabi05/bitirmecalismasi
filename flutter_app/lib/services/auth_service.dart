import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _db = FirestoreService();

  // Get current user stream
  Stream<User?> get userStream => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with Email and Password
  Future<UserCredential?> signInWithEmailPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Surface a readable reason to the UI instead of silently failing.
      throw AuthException(_messageForCode(e));
    }
  }

  // Register with Email and Password
  Future<UserCredential?> registerWithEmailPassword(String name, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Create user document in Firestore
      if (credential.user != null) {
        UserModel newUser = UserModel(
          userId: credential.user!.uid,
          name: name,
          email: email,
          createdAt: DateTime.now(),
        );
        await _db.createUser(newUser);
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      // e.g. 'email-already-in-use' now reaches the UI as a clear message.
      throw AuthException(_messageForCode(e));
    }
  }

  // Maps a FirebaseAuthException code to a user-friendly message.
  String _messageForCode(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered. Try logging in instead.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled for this project.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }

  // Update email
  Future<bool> updateEmail(String newEmail) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.verifyBeforeUpdateEmail(newEmail);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating email: $e');
      return false;
    }
  }

  // Update password
  Future<bool> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating password: $e');
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

/// Thrown by [AuthService] carrying a message that is ready to show to the user.
/// Its [toString] is the bare message, so the UI can display it directly.
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
