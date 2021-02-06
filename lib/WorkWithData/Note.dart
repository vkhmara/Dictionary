import 'Language.dart';

class Note {
  Word word;
  /// [translation] is always in Russian
  Word translation;
  DateTime dateOfNote;
  bool learnt;

  Note(this.word, this.translation, this.dateOfNote, this.learnt);

  Note.fromNote(Note note):
        word = Word.fromWord(note.word),
        translation = note.translation,
        dateOfNote = note.dateOfNote,
        learnt = note.learnt;


  Note.fromJson(Map<String, dynamic> json)
      :
        word=Word(json['word'], Language.fromString(json['wordLang'])),
        translation=Word(json['trans'], Russian()),
        dateOfNote=DateTime.parse(json["dateOfNote"]),
        learnt=json["learnt"] == 0 ? false : true;

  bool isValid() {
    return 1 <= word.word.length && word.word.length <= 24 &&
        1 <= translation.word.length && translation.word.length <= 24;
  }

  void cleanHebrewWord() {
    word.cleanSelf();
  }
}
