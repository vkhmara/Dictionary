import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:hebrew_dictionary/WorkWithData/DateTimeUtility.dart';
import 'package:sqflite/sqflite.dart';

import 'Note.dart';

class DatabaseManager extends ChangeNotifier {
  Database _db;
  static const String _TABLE_NAME = "Dictionary";

  bool get isInit {
    return _db != null;
  }

  Future<void> initDB() async {
    if (isInit) {
      return;
    }
    String dir = await getDatabasesPath();
    String path = dir + '/Database.db';
    _db = await openDatabase(path, version: 1,
        onOpen: (db) async {},
        onCreate: (Database db, int version) async {
          await db.execute("""CREATE TABLE IF NOT EXISTS $_TABLE_NAME (
          dateOfNote DATETIME PRIMARY KEY NOT NULL,
          word VARCHAR(24),
          wordLang VARCHAR(4),
          trans VARCHAR(24),
          learnt BIT
          )""");
        });
    log('database init');
  }

  Future<void> editNote(Note oldNote, Note newNote) async {
    await _db.execute("""UPDATE $_TABLE_NAME
    SET word = \"${newNote.word.word}\",
    wordLang = \"${newNote.word.language.toString()}\",
    trans = \"${newNote.translation.word}\",
    dateOfNote = \"${DateTimeUtility.dateTimeToString(newNote.dateOfNote)}\",
    learnt = ${newNote.learnt ? 1 : 0}
    WHERE dateOfNote = \"${DateTimeUtility.dateTimeToString(oldNote.dateOfNote)}\";
    """);
    log('note edited');
  }

  Future<void> addNote(Note note) async {
    await _db.execute(
        """INSERT INTO $_TABLE_NAME (word, wordLang, trans, dateOfNote, learnt) VALUES (
    \"${note.word.word}\",
    \"${note.word.language.toString()}\",
    \"${note.translation.word}\",
    \"${DateTimeUtility.dateTimeToString(note.dateOfNote)}\",
    ${note.learnt ? 1 : 0})
    """);
    log('note added');
  }

  Future<void> deleteNote(Note note) async {
    await _db.execute("""DELETE FROM $_TABLE_NAME
    WHERE dateOfNote=\"${DateTimeUtility.dateTimeToString(note.dateOfNote)}\"""");
    log('note deleted');
  }

  Future<List<Note>> getDict(Language language) async{
    return (await _db.rawQuery("""select * from $_TABLE_NAME
    WHERE wordLang=\"${language.toString()}\"
    """)).map((e)=>Note.fromJson(e)).toList();
  }

}