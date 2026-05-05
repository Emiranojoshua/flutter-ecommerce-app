import 'package:ecommerce_app/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  AuthUser? get currentUser;
  Future<void> initialize();
}