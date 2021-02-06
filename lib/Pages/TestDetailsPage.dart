import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hebrew_dictionary/HelperComponents/ScreenCenterForm.dart';
import 'package:hebrew_dictionary/Settings/Settings.dart';
import 'package:hebrew_dictionary/WorkWithData/Note.dart';
import 'package:hebrew_dictionary/WorkWithData/TestingSystem.dart';

class TestDetailsPage extends StatelessWidget {
  static const String route = 'TestDetailsPage';

  Widget resultNote(Note note, String userAnswer, bool origin) {
    bool correct = origin ?
    userAnswer == note.translation.word
        : userAnswer == note.word.word;
    return Container(
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.4)
          )
      ),
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            origin ? note.word.word.replaceAll(' ', '\n').replaceAll(' ', '\n') :
            note.translation.word.replaceAll(' ', '\n').replaceAll(' ', '\n'),
            style: TextStyle(
                fontSize: 20.0
            ),
          ),
          Column(
            children: [
              Text(
                'Ваш ответ:'
              ),
              Text('${userAnswer == '' ? 'нет ответа' : userAnswer.replaceAll(' ', '\n')}',
                style: TextStyle(
                  color: correct ? Colors.green : Colors.red,
                ),
              ),
              Text('Правильный ответ:'),
              Text('${!origin ? note.word.word.replaceAll(' ', '\n') : note
                  .translation.word.replaceAll(' ', '\n')}',
                style: TextStyle(
                  color: Colors.green,
                ),)
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TestingSystem testingSystem = ModalRoute
        .of(context)
        .settings
        .arguments;
    List<Note> testList = testingSystem.testList;
    List<String> userAnswers = testingSystem.userAnswers;

    return Scaffold(
      appBar: AppBar(
        title: Text('Результаты теста'),
      ),
      body: ScreenCenterForm(
          child: SizedBox(
            height: 600.0,
            child: ListView.builder(
                itemCount: testingSystem.countWords,
                itemBuilder: (context, index) =>
                    resultNote(testList[index], userAnswers[index], testingSystem.origin)
            ),
          ),
        width: 300.0,
      ),
    );
  }
}
