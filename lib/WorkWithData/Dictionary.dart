import 'package:flutter/cupertino.dart';
import 'package:hebrew_dictionary/WorkWithData/Note.dart';

class Dictionary<T extends Language> extends ChangeNotifier {
  List<Note> _dict;

  void initDict(List<Note> dict) {
    _dict = dict.toList();
  }

  void editNote(Note oldNote, Note newNote) {
    if (_dict.contains(oldNote)) {
      int index = _dict.indexOf(oldNote);
      _dict.replaceRange(index, index + 1, [newNote]);
      notifyListeners();
    }
  }

  void addNote(Note note) {
    _dict.add(note);
    notifyListeners();
  }

  void deleteNote(Note note) {
    _dict.remove(note);
    notifyListeners();
  }

  void deleteNoteAt(int index) {
    _dict.removeAt(index);
    notifyListeners();
  }

  Note at(int index) {
    return _dict[index];
  }

  bool contains(Word word) {
    return _dict.any((element) => Word.equal(element.word, word));
  }

  List<Note> find(String prefix) {
    if (prefix == '') {
      return _dict.toList();
    }
    return _dict.where((note) => note.word.startsWith(prefix)).toList();
  }

  List<Note> fromPeriod(DateTime start, DateTime end) {
    return _dict.where((note) =>
    start.isBefore(note.dateOfNote) && note.dateOfNote.isBefore(end)).toList();
  }

  List<Note> dictInAlphabetOrder() {
    return List()
      ..addAll(_dict)
      ..sort((note1, note2) => note1.word.word.compareTo(note2.word.word));
  }

  List<Note> findTrans(Word word) {
    return _dict.where((note) => Word.equal(note.translation, word)).toList();
  }

  List<Note> get dict => _dict.toList();

  int get size => _dict.length;

}
