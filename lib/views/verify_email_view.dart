import 'package:ecommerce_app/services/auth/auth_exception.dart';
import 'package:ecommerce_app/services/auth/auth_service.dart';
import 'package:ecommerce_app/util/dialogs.dart';
import 'package:ecommerce_app/util/routes.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Please verify your email"),
            TextButton(
              onPressed: () async {
                // Handle resending email
                try {
                  await AuthService.firebase()
                      .sendEmailVerification();
                  await showErrorDialog(
                    context,
                    "Verification email sent",
                  );
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
                  await showErrorDialog(context, e.toString());
                }
              },
              child: Text("send email verification"),
            ),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  LOGINROUTE,
                  (_) => false,
                );
              },
              child: const Text("Restart"),
            ),
          ],
        ),
      ),
    );
  }
}

enum MenuItems { logout }

const List<String> lis = ["a", "b", "c"];
