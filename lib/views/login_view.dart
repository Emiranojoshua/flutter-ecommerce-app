import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/util/dialogs.dart';
import 'package:ecommerce_app/util/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login"), centerTitle: true),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              return Center(
                child: Column(
                  children: [
                    TextField(
                      autocorrect: false,
                      enableSuggestions: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                      ),
                      controller: _emailController,
                    ),
                    TextField(
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      keyboardType:
                          TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                      ),
                      controller: _passwordController,
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final email = _emailController.text
                                .trim();
                            final password = _passwordController
                                .text
                                .trim();
                            try {
                              final userCredential =
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                        email: email,
                                        password: password,
                                      );

                              final user = FirebaseAuth
                                  .instance
                                  .currentUser;

                              final emailVerified =
                                  user?.emailVerified ?? false;
                                  
                              if (emailVerified) {
                                Navigator.of(
                                  context,
                                ).pushNamedAndRemoveUntil(
                                  NOTESROUTE,
                                  (_) => false,
                                );
                                
                                // return;
                              } else {
                                Navigator.of(
                                  context,
                                ).pushNamedAndRemoveUntil(
                                  VERIFYEMAILROUTE,
                                  (_) => false,
                                );
                                
                              }
                            } on FirebaseAuthException catch (
                              e
                            ) {
                              await showErrorDialog(
                                context,
                                e.code.toString(),
                              );
                            }
                          },
                          child: Text("Login"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamedAndRemoveUntil(
                              REGISTERROUTE,
                              (route) => false,
                            );
                          },
                          child: Text(
                            "Not registered, Register here",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );

            default:
              return const Center(child: Text("Loading"));
          }
        },
      ),
    );
  }
}
