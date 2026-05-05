import 'package:ecommerce_app/util/routes.dart';
import 'package:ecommerce_app/views/notes_homepage.dart';
import 'package:ecommerce_app/views/notes_view.dart';
import 'package:ecommerce_app/views/login_view.dart';
import 'package:ecommerce_app/views/register_view.dart';
import 'package:ecommerce_app/views/verify_email_view.dart';

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
