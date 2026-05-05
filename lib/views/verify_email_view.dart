import 'package:ecommerce_app/util/dialogs.dart';
import 'package:ecommerce_app/util/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
                  final verified = user?.emailVerified ?? false;
                  print(!verified);
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
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                  await showErrorDialog(context, "Verification email sent");
                } on FirebaseAuthException catch (e) {
                  await showErrorDialog(
                    context,
                    e.code.toString(),
                  );
                } catch (e) {
                  await showErrorDialog(context, e.toString());
                }
              },
              child: Text("send email verification"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
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
