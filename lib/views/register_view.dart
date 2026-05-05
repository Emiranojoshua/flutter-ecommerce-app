import 'package:ecommerce_app/services/auth/auth_exception.dart';
import 'package:ecommerce_app/services/auth/auth_service.dart';
import 'package:ecommerce_app/util/dialogs.dart';
import 'package:ecommerce_app/util/routes.dart';
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
                      await AuthService.firebase().createUser(
                        email: email,
                        password: password,
                      );
                      // final user = AuthService.firebase().currentUser;
                      await AuthService.firebase()
                          .sendEmailVerification();
                      Navigator.of(
                        context,
                      ).pushNamed(VERIFYEMAILROUTE);
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
                  child: Text("Already have an account?, Login"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
