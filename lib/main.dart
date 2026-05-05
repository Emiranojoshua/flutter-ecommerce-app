import 'package:ecommerce_app/counterApp/learning_notifier.dart';
import 'package:ecommerce_app/counterApp/new_app.dart';
import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/util/routes.dart';
import 'package:ecommerce_app/views/notes_view.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/screens/home_page.dart';
import 'package:ecommerce_app/views/login_view.dart';
import 'package:ecommerce_app/views/register_view.dart';
import 'package:ecommerce_app/views/verify_email_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/main_app.dart';

import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlutterApp());
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const NotesHomePage(),
      routes: {
        LOGINROUTE: (context) => LoginView(),
        REGISTERROUTE: (context) => RegisterView(),
        VERIFYEMAILROUTE: (context) => VerifyEmailView(),
        NOTESROUTE: (context) => NotesView(),
      },
    );
  }
}

class NotesHomePage extends StatelessWidget {
  const NotesHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, asyncSnapshot) {
        switch (asyncSnapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            final emailVerified = user?.emailVerified ?? false;
            if (user != null) {
              if (!emailVerified) {
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
