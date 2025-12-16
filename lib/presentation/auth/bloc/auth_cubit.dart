import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Auth States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

// Auth Cubit
class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthCubit() : super(AuthInitial());

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (credential.user != null) {
        emit(AuthSuccess(credential.user!));
      } else {
        emit(AuthFailure("Sign in failed. Please try again."));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_getFirebaseErrorMessage(e.code)));
    } catch (e) {
      emit(AuthFailure("An unexpected error occurred: $e"));
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      if (credential.user != null) {
        // Store user data in Firestore
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'fullname': name.trim(),
          'email': email.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        emit(AuthSuccess(credential.user!));
      } else {
        emit(AuthFailure("Registration failed. Please try again."));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_getFirebaseErrorMessage(e.code)));
    } catch (e) {
      emit(AuthFailure("An unexpected error occurred: $e"));
    }
  }

  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Invalid email address.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
