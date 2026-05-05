import 'package:ecommerce_app/util/dialogs.dart';
import 'package:ecommerce_app/util/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main UI"),
        actions: [
          PopupMenuButton<MenuItem>(
            onSelected: (value) async {
              switch (value) {
                case MenuItem.logout:
                  final logout =
                      await showLogoutDialog(context) ?? false;
                  if (logout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(
                      LOGINROUTE,
                      (route) => false,
                    );
                  }

                // throw UnimplementedError();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<MenuItem>(
                child: const Text("Logout"),
                value: MenuItem.logout,
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [Text("main ui text")]),
      ),
    );
  }
}

enum MenuItem { logout }
