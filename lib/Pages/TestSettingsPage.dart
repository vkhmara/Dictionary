import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hebrew_dictionary/HelperComponents/DatePicker.dart';
import 'package:hebrew_dictionary/Pages/TestingPage.dart';
import 'package:hebrew_dictionary/WorkWithData/Dictionary.dart';
import 'package:hebrew_dictionary/WorkWithData/Note.dart';
import 'package:hebrew_dictionary/WorkWithData/TestingSystem.dart';
import 'package:provider/provider.dart';

import 'TestResultPage.dart';

class TestSettingsPage extends StatefulWidget {
  @override
  _TestSettingsPageState createState() => _TestSettingsPageState();
}

class _TestSettingsPageState extends State<TestSettingsPage> {
  Language _chosenLanguage = Hebrew();
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now();
  bool _origin = true;
  bool _allTime = false;
  bool _allWords = false;
  bool _someError = false;
  TextEditingController _tec = TextEditingController();
  TestingSystem _testingSystem;
  bool _testMode = false;
  bool _resultTestMode = false;
  bool _onlyLearnt = false;
  bool _onlyNotLearnt = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    if (_resultTestMode) {
      return TestResultPage(_testingSystem, () {
        setState(() {
          _testMode = _resultTestMode = false;
        });
      });
    }
    if (_testMode) {
      return TestingPage(_testingSystem, () {
        setState(() {
          _resultTestMode = true;
        });
      });
    }
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'Выберите количество слов (>=5)'
              ),
              SizedBox(width: 10.0,),
              SizedBox(
                width: 40,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _tec,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('или выберите все слова'),
              Checkbox(
                  value: _allWords,
                  onChanged: (b) {
                    setState(() {
                      _allWords = !_allWords;
                    });
                  }
              )
            ],
          ),
          SizedBox(height: 40.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Выберите язык',
              ),
              PopupMenuButton(
                  onSelected: (typename) {
                    setState(() {
                      _chosenLanguage = Language.fromString(typename);
                    });
                  },
                  child: Container(
                    color: Color(0x20808080),
                    padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                    margin: EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        Text(
                            _chosenLanguage.toString()
                        ),
                        Icon(Icons.arrow_drop_down_sharp),
                      ],
                    ),
                  ),
                  itemBuilder: (context) =>
                  [
                    PopupMenuItem(
                      child: Text('heb'),
                      value: 'heb',
                    ),
                    PopupMenuItem(
                      child: Text('eng'),
                      value: 'eng',
                    ),
                  ]
              )
            ],
          ),
          SizedBox(height: 40.0,),
          Container(
            alignment: Alignment.center,
            child: Text(
                'Введите интервал времени'
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 160.0,
                child: DatePicker(
                  labelText: 'Начало',
                  selectedDate: _start,
                  selectDate: (value) {
                    setState(() {
                      _start = value;
                    });
                  },
                ),
              ),
              SizedBox(
                width: 160.0,
                child: DatePicker(
                  labelText: 'Конец',
                  selectedDate: _end,
                  selectDate: (value) {
                    setState(() {
                      _end = value;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('или выберите весь период времени'),
              Checkbox(
                  value: _allTime,
                  onChanged: (b) {
                    setState(() {
                      _allTime = !_allTime;
                    });
                  }
              )
            ],
          ),
          SizedBox(height: 40.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Тестирование по переводу'),
              Checkbox(
                value: !_origin,
                onChanged: (b) {
                  setState(() {
                    _origin = !_origin;
                  });
                },
              )
            ],
          ),
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Только выученные слова'),
              Checkbox(
                value: _onlyLearnt,
                onChanged: (b) {
                  setState(() {
                    _onlyLearnt = !_onlyLearnt;
                    if (_onlyLearnt) {
                      _onlyNotLearnt = false;
                    }
                  });
                },
              )
            ],
          ),
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Только невыученные слова'),
              Checkbox(
                value: _onlyNotLearnt,
                onChanged: (b) {
                  setState(() {
                    _onlyNotLearnt = !_onlyNotLearnt;
                    if (_onlyNotLearnt) {
                      _onlyLearnt = false;
                    }
                  });
                },
              )
            ],
          ),
          SizedBox(height: 40.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _someError ? _errorMessage : '',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text('Начать тестирование'),
                  onPressed: () {
                    int wordCount;
                    try {
                      wordCount = int.parse(_tec.text);
                      if (wordCount < TestingSystem.MIN_WORDS) {
                        throw Exception('Маловато будет, маловато');
                      }
                    }
                    on FormatException {
                      setState(() {
                        _someError = true;
                        _errorMessage = 'Неправильный ввод количества слов';
                      });
                    }
                    catch (e) {
                      if (!_allWords) {
                        setState(() {
                          _someError = true;
                          _errorMessage = 'Слишком мало слов, чтобы начать тестирование';
                        });
                        return;
                      }
                    }
                    if (_allTime) {
                      _start = DateTime(2021);
                      _end = DateTime.now();
                    }
                    if (_allWords) {
                      wordCount = 0;
                    }
                    _testingSystem = TestingSystem(
                        wordCount, _start, _end, _origin,
                        _chosenLanguage.runtimeType == Hebrew ?
                        Provider.of<Dictionary<Hebrew>>(context) :
                        Provider.of<Dictionary<English>>(context),
                      _onlyLearnt, _onlyNotLearnt
                    );
                    if (_testingSystem.countWords < TestingSystem.MIN_WORDS) {
                      setState(() {
                        _someError = true;
                        _errorMessage = 'Слишком мало слов, чтобы начать тестирование';
                      });
                      return;
                    }
                    setState(() {
                      _testMode = true;
                      _someError = false;
                    });
                  }),
              ]
          ),
        ],
      ),
    );
  }
}
