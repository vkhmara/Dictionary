import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hebrew_dictionary/HelperComponents/ScreenCenterForm.dart';
import 'package:hebrew_dictionary/WorkWithData/Note.dart';
import 'package:hebrew_dictionary/WorkWithData/TestingSystem.dart';

class TestingPage extends StatefulWidget {
  final TestingSystem _testingSystem;
  final void Function() _toResultPage;
  TestingPage(this._testingSystem, this._toResultPage);
  @override
  _TestingPageState createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {

  TextEditingController _tec = TextEditingController();
  Note _currentNote;
  bool _checked = false;
  bool _correctAnswer = false;


  @override
  void initState() {
    super.initState();
    _currentNote = widget._testingSystem.current();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenCenterForm(
      child: Column(
        children: [
        Text(
          widget._testingSystem.origin ? _currentNote.word.word : _currentNote
              .translation
              .word,
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(height: 30.0,),
        SizedBox(
          width: 100.0,
          child: TextField(
            controller: _tec,
          ),
        ),
        SizedBox(height: 20.0,),
        SizedBox(height: 40.0,
          child: Text(
              _checked ? (_correctAnswer
                  ? 'Правильно'
                  : 'Неправильно') : '',
              style: TextStyle(
                color: _correctAnswer ? Colors.green : Colors.red,
              )
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _checked ? ([
            RaisedButton(
              child: Text('Дальше'),
              onPressed: () {
                try {
                  setState(() {
                    _tec.text = '';
                    _currentNote = widget._testingSystem.next();
                    _checked = false;
                  });
                }
                catch (e) {
                  widget._toResultPage();
                }
              },
            )
          ])
              :
          [
            RaisedButton(
                child: Text('Проверить'),
                onPressed: () {
                  _correctAnswer = widget._testingSystem.checkAnswer(
                      _tec.text);
                  setState(() {
                    _checked = true;
                  });
                }
            ),
          ],
        ),
      ],
    ));
  }
}
