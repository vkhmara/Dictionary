import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hebrew_dictionary/HelperComponents/ScreenCenterForm.dart';
import 'package:hebrew_dictionary/Pages/TestDetailsPage.dart';
import 'package:hebrew_dictionary/WorkWithData/TestingSystem.dart';

class TestResultPage extends StatefulWidget {
  final void Function() _toTestSettingsPage;
  final TestingSystem _testingSystem;
  TestResultPage(this._testingSystem, this._toTestSettingsPage);
  @override
  _TestResultPageState createState() => _TestResultPageState();
}

class _TestResultPageState extends State<TestResultPage> {

  @override
  Widget build(BuildContext context) {
    return ScreenCenterForm(
        child: Column(
          children: [
            Text(
              'Результаты',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 15.0,),
            Text(
              '${widget._testingSystem.correctAnswers}/'
                  '${widget._testingSystem.countWords}',
            ),
            SizedBox(height: 15.0,),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context, TestDetailsPage.route,
                    arguments: widget._testingSystem);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Посмотреть подробности',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10.0,),
            RaisedButton(
                child: Text('На главную'),
                onPressed: () {
                  widget._toTestSettingsPage();
                }),
          ],
        )
    );
  }
}
