import 'package:ecommerce_app/services/auth/auth_exception.dart';
import 'package:ecommerce_app/services/auth/auth_service.dart';
import 'package:ecommerce_app/util/dialogs.dart';
import 'package:ecommerce_app/util/routes.dart';
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
      body: Center(
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
              keyboardType: TextInputType.visiblePassword,
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
                    final email = _emailController.text.trim();
                    final password = _passwordController.text
                        .trim();
                    try {
                      await AuthService.firebase().logIn(
                        email: email,
                        password: password,
                      );

                      final user =
                          AuthService.firebase().currentUser;

                      final emailVerified =
                          user?.isEmailVerified ?? false;

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
                    } on UserNotLoggedInAuthException {
                      await showErrorDialog(
                        context,
                        "User not logged in",
                      );
                    } on WeakPasswordAuthException {
                      await showErrorDialog(
                        context,
                        "Weak password",
                      );
                    } on InvalidEmailAuthException {
                      await showErrorDialog(
                        context,
                        "Invalid email",
                      );
                    } on EmailAlreadyInUseAuthException {
                      await showErrorDialog(
                        context,
                        "Email already in use",
                      );
                    } on GenericAuthException {
                      await showErrorDialog(
                        context,
                        "Authentication error",
                      );
                    } catch (e) {
                      await showErrorDialog(
                        context,
                        e.toString(),
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
                  child: Text("Not registered, Register here"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
