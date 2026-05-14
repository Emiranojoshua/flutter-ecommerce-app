import 'package:ecommerce_app/services/auth/auth_service.dart';
import 'package:ecommerce_app/services/auth/note_service.dart';
import 'package:ecommerce_app/util/dialogs.dart';
import 'package:ecommerce_app/util/enum/menu_item.dart';
import 'package:ecommerce_app/util/routes.dart';
import 'package:flutter/material.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NoteService _noteService;

  String get userEmail =>
      AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    super.initState();
    _noteService = NoteService();
  }

  @override
  void dispose() {
    _noteService.close();
    super.dispose();
  }

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
                    await AuthService.firebase().logOut();
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
                value: MenuItem.logout,
                child: const Text("Logout"),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: _noteService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _noteService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text("Waiting for all notes");

                    case ConnectionState.done:
                      // TODO: Handle this case.
                      throw UnimplementedError();
                    default:
                      return CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
