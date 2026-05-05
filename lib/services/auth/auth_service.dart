import 'package:ecommerce_app/services/auth/auth_provider.dart';
import 'package:ecommerce_app/services/auth/auth_user.dart';
import 'package:ecommerce_app/services/auth/firebase_auth_provider.dart';
import 'package:flutter/cupertino.dart';

@immutable
class AuthService implements AuthProvider {
  final AuthProvider _authProvider;

  const AuthService(this._authProvider);

  factory AuthService.firebase() =>
      AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) {
    return _authProvider.createUser(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _authProvider.currentUser;

  @override
  Future<void> initialize() {
    return _authProvider.initialize();
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    return _authProvider.logIn(email: email, password: password);
  }

  @override
  Future<void> logOut() {
    return _authProvider.logOut();
  }

  @override
  Future<void> sendEmailVerification() {
    return _authProvider.sendEmailVerification();
  }
}
