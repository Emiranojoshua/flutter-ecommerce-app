
import 'package:ecommerce_app/services/auth/auth_service.dart';
import 'package:ecommerce_app/views/login_view.dart';
import 'package:ecommerce_app/views/notes_view.dart';
import 'package:ecommerce_app/views/verify_email_view.dart';
import 'package:flutter/material.dart';

class NotesHomePage extends StatelessWidget {
  const NotesHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, asyncSnapshot) {
        switch (asyncSnapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            final emailVerified = user?.isEmailVerified ?? false;
            if (user != null) {
              if (emailVerified) {
                return NotesView();
                // return;
              } else {
                return VerifyEmailView();
              }
            } else {
              return LoginView();
            }

          default:
            return Scaffold(
              body: const Center(child: Text("Loading")),
            );
        }
      },
    );
  }
}
