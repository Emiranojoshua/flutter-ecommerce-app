import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/util/dialogs.dart';
import 'package:ecommerce_app/util/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: Text("Register"), centerTitle: true),
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
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                              final user = FirebaseAuth
                                  .instance
                                  .currentUser;
                              await user
                                  ?.sendEmailVerification();
                              Navigator.of(
                                context,
                              ).pushNamed(VERIFYEMAILROUTE);
                            } on FirebaseAuthException catch (
                              e
                            ) {
                              await showErrorDialog(
                                context,
                                e.code.toString(),
                              );
                            } catch (e) {
                              await showErrorDialog(
                                context,
                                e.toString(),
                              );
                            }
                          },
                          child: Text("Register"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamedAndRemoveUntil(
                              LOGINROUTE,
                              (route) => false,
                            );
                          },
                          child: Text(
                            "Already have an account?, Login",
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
