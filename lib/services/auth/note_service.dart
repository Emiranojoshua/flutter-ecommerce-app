import 'dart:async';

import 'package:ecommerce_app/services/crud/crud_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show
        getApplicationDocumentsDirectory,
        MissingPlatformDirectoryException;
import 'package:path/path.dart' show join;

class NoteService {
  Database? _db;

  List<DatabaseNote> _notes = [];

  final _notesStreamController =
      StreamController<List<DatabaseNote>>.broadcast();

  static final NoteService _shared = NoteService._internal();
  NoteService._internal();
  factory NoteService() => _shared;

  Stream<List<DatabaseNote>> get allNotes =>
      _notesStreamController.stream;

  Future<DatabaseUsers> getOrCreateUser({
    required String email,
  }) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUserException {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);
    final updateCount = await db.update(noteTable, {
      'textColumn': text,
      'isSyncedWithCloudColumn': 0,
    });

    if (updateCount == 0) {
      throw CouldNotUpdateNoteException();
    }
    {
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
    }
  }

  Future<Iterable<DatabaseNote>> getAllNote() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((noteRow) => DatabaseNote.fromMap(noteRow));
  }

  Future<DatabaseNote> getNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: "id = ?",
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFindNoteException();
    } else {
      final note = DatabaseNote.fromMap(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<int> deleteAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberDeleted = await db.delete(noteTable);
    _notes.clear();
    _notesStreamController.add(_notes);
    return numberDeleted;
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = db.delete(
      noteTable,
      where: "id = ?",
      whereArgs: [id],
    );

    if (deletedCount == 0) {
      throw CouldNotDeleteNoteException();
    } else {
      final countBefore = _notes.length;
      _notes.removeWhere((note) => note.id == id);
      if (_notes.length != countBefore) {
        _notesStreamController.add(_notes);
      }
    }
  }

  Future<DatabaseNote> createNote({
    required DatabaseUsers owner,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final dbUser = await getUser(email: owner.email);

    if (owner != dbUser) {
      throw CouldNotFindUserException();
    }

    const text = "";

    final noteId = await db.insert(noteTable, {
      'userIdColumn': owner.id,
      'textColumn': text,
      'isSyncedWithCloudColumn': 1,
    });

    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncyedWithCloud: true,
    );
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<DatabaseUsers> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );

    if (result.isEmpty) {
      throw CouldNotFindUserException();
    } else {
      return DatabaseUsers.fromMap(result.first);
    }
  }

  Future<DatabaseUsers> createUser({
    required String email,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );

    if (result.isNotEmpty) {
      throw UserAlreadyExistException();
    }

    final userId = await db.insert(userTable, {
      email: email.toLowerCase(),
    });

    return DatabaseUsers(email: email, id: userId);
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final deletedUser = await db.delete(
      userTable,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );

    if (deletedUser != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // empty
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final docsName = join(docsPath.path, dbName);
      final db = await openDatabase(docsName);
      _db = db;

      await db.execute(createUserTable);

      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectoryException();
    } catch (e) {
      e.toString();
    }
  }
}

@immutable
class DatabaseUsers {
  final String email;
  final int id;

  const DatabaseUsers({required this.email, required this.id});

  DatabaseUsers.fromMap(Map<String, dynamic> map)
    : id = map['id'] as int,
      email = map['email'] as String;

  @override
  String toString() {
    return 'Person, ID = $id, email = $email';
  }

  @override
  bool operator ==(covariant DatabaseUsers other) =>
      id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncyedWithCloud;

  const DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncyedWithCloud,
  });

  DatabaseNote.fromMap(Map<String, Object?> map)
    : id = map['id'] as int,
      userId = map['email'] as int,
      text = map['text'] as String,
      isSyncyedWithCloud =
          (map['isSyncyedWithCloud'] as int) == 1 ? true : false;

  @override
  String toString() =>
      "Note, ID = $id, userId = $userId, isSyncyedWithCloud = $isSyncyedWithCloud";

  @override
  bool operator ==(covariant DatabaseNote other) =>
      id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = "notes.db";
const noteTable = "note";
const userTable = "user";

const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
              "id"	INTEGER NOT NULL,
              "email"	TEXT NOT NULL UNIQUE,
              PRIMARY KEY("id" AUTOINCREMENT)
              );
            ''';
const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
                "id"	INTEGER NOT NULL,
                "user_id"	INTEGER NOT NULL,
                "text"	TEXT,
                "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
                PRIMARY KEY("id"),
                FOREIGN KEY("user_id") REFERENCES "user"("id")
              );
          ''';
