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
  static const String NEKUDOT = ' ְ ֶ ֵ ּ ַ ִ ֹ ֲ ֱ ֳ ֹ ֻ ׂ ';
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
    List<String> list = hebWord.split('').toList().where((char) =>
    Hebrew.NEKUDOT.indexOf(char) == -1).toList();
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
