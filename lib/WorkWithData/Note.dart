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

class Language {
  String alphabet;
  Language() {
    alphabet = '.,()!?:;-_— ';
  }
  String toString() {
    switch(this.runtimeType) {
      case Hebrew:
        return 'heb';
      case Russian:
        return 'rus';
      case English:
        return 'eng';
      default:
        return 'undefined';
    }
  }
  static Language fromString(String typename) {
    switch (typename) {
      case 'rus': return Russian();
      case 'eng': return English();
      case 'heb': return Hebrew();
      default: return Russian();
    }
  }
}

class Hebrew extends Language {
  Hebrew() {
    alphabet += ' ְ ֶ ֵ ּ ַ ִ ֹ ֲ ֱ ֳ ֹ ֻ ׂ ָקראטוןםפשדגכעיחלךףזסבהנמצתץ';
  }
}

class English extends Language {
  English() {
    StringBuffer str = StringBuffer('qwertyuiopasdfghjklzxcvbnm');
    str.write(str.toString().toUpperCase());
    alphabet += str.toString();
  }
}

class Russian extends Language {
  Russian() {
    StringBuffer str = StringBuffer('йцукенгшщзхъфывапролджэячсмитьбюё');
    str.write(str.toString().toUpperCase());
    alphabet += str.toString();
  }
}

class Word {
  String _word;
  Language language;
  Word(String word, Language language) {
    if (word.split('').any(
            (char) => !language.alphabet.contains(char))) {
      throw Exception('Word is incompatible with alphabet');
    }
    this._word = word.toLowerCase();
    this.language = language;
  }

  Word.fromWord(Word word):
      _word=word.word,
      language=word.language;

  String get word => _word;

  set word(String value) {
    try {
      Word(value, language);
      _word = value;
    }
    catch(e) {
      throw Exception('Word is incompatible with alphabet');
    }
  }

  static String cleanHebWord(String hebWord) {
    List<String> list = hebWord.split('').toList().where((element) =>
    ('א'.compareTo(element) <= 0 && element.compareTo('ת') <= 0) ||
        element == ' ').toList();
    return list.join();
  }

  static bool equal(Word word1, Word word2) {
    if (word1.language.runtimeType != word2.language.runtimeType) {
      return false;
    }
    return word1.word == word2.word;
  }

  bool startsWith(String prefix) {
    if (language.runtimeType == Hebrew) {
      return cleanHebWord(_word).startsWith(prefix);
    }
    return _word.startsWith(prefix);
  }

  void cleanSelf() {
    if (language.runtimeType != Hebrew) {
      return;
    }
    word = cleanHebWord(word);
  }
}
