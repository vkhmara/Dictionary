import 'package:hebrew_dictionary/WorkWithData/Dictionary.dart';
import 'package:hebrew_dictionary/WorkWithData/Note.dart';

import 'Language.dart';

class TestingSystem {
  static const int MIN_WORDS = 5;
  List<Note> _testList;
  List<bool> _correct;
  List<String> _userAnswers;
  bool _origin;
  int _currentIndex = 0;


  TestingSystem(int wordCount, DateTime start, DateTime end, this._origin,
      Dictionary list, bool onlyLearnt, bool onlyNotLearnt) {
    _testList = list.fromPeriod(start, end);
    if (onlyLearnt) {
      _testList.removeWhere((element) => !element.learnt);
    }
    else if (onlyNotLearnt) {
      _testList.removeWhere((element) => element.learnt);
    }
    _testList.shuffle();
    if (wordCount >= MIN_WORDS && wordCount < _testList.length) {
      _testList = _testList.sublist(0, wordCount);
    }
    _correct = List(_testList.length);
    _userAnswers = List(_testList.length);
    if (_testList[0].word.language.runtimeType == Hebrew && !_origin) {
      for (int i = 0; i < _testList.length; i++) {
        _testList[i].cleanHebrewWord();
      }
    }
  }

  Note next() {
    if (++_currentIndex >= _testList.length) {
      throw Exception('It is all');
    }
    return _testList[_currentIndex];
  }

  Note current() {
    if (_currentIndex >= _testList.length) {
      throw Exception('It is all');
    }
    return _testList[_currentIndex];
  }

  bool checkAnswer(String inputWord) {
    Note note = current();
    _userAnswers[_currentIndex] = inputWord;
    if (_origin) {
      _correct[_currentIndex] = inputWord == note.translation.word;
    }
    else {
      _correct[_currentIndex] = inputWord == note.word.word;
    }
    return _correct[_currentIndex];
  }

  int get countWords => _testList.length;

  int get correctAnswers =>
      _correct
          .where((element) => element == true)
          .toList()
          .length;

  bool get origin => _origin;

  List<bool> get correct => _correct;

  List<Note> get testList => _testList;

  List<String> get userAnswers => _userAnswers;
}