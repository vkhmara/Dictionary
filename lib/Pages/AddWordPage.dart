import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hebrew_dictionary/Settings/Settings.dart';
import 'package:hebrew_dictionary/WorkWithData/DatabaseManager.dart';
import 'package:hebrew_dictionary/WorkWithData/Dictionary.dart';
import 'package:hebrew_dictionary/WorkWithData/Note.dart';
import 'package:provider/provider.dart';

class AddWordPage extends StatefulWidget {
  @override
  _AddWordPageState createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> {
  TextEditingController tecWord = TextEditingController();
  TextEditingController tecTrans = TextEditingController();
  bool added = false;
  bool someError = false;

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    return ListView(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(20.0),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(settings.language.runtimeType == Hebrew ? 'Иврит' : 'Английский'),
                  SizedBox(
                    child: TextFormField(
                      controller: tecWord,
                      maxLength: 24,
                    ),
                    width: 160.0,
                  ),
                  SizedBox(height: 20.0,),
                  Text('Русский'),
                  SizedBox(
                    child: TextFormField(
                      controller: tecTrans,
                      maxLength: 24,
                    ),
                    width: 160.0,
                  ),
                  SizedBox(height: 20.0,),
                  RaisedButton(
                      child: Text('Добавить слово'),
                      color: Color(0xE0FFFFFF),
                      onPressed: () async {
                        added = false;
                        Dictionary dict;
                        Word word, trans;
                        if (settings.language.runtimeType == Hebrew) {
                          dict = Provider.of<Dictionary<Hebrew>>(context);
                        }
                        else {
                          dict = Provider.of<Dictionary<English>>(context);
                        }
                        try {
                          word = Word(tecWord.text, settings.language);
                          trans = Word(tecTrans.text, Russian());
                        }
                        catch (e) {
                          setState(() {
                            someError = true;
                          });
                          return;
                        }
                        if (dict.contains(word)) {
                          setState(() {
                            someError = true;
                          });
                          return;
                        }
                        Note note = Note(word, trans,
                            DateTime.now(), false);
                        if (!note.isValid()) {
                          setState(() {
                            someError = true;
                          });
                        }
                        else {
                          dict.addNote(note);
                          await Provider.of<DatabaseManager>(context).addNote(
                              note);
                          someError = false;
                          setState(() {
                            added = true;
                          });
                        }
                      }
                  ),
                  someError || added ?
                  SizedBox(height: 40.0,
                    child: Text(
                      someError ? 'Неправильный ввод' : 'Слово добавлено',
                      style: TextStyle(color: Colors.red),
                    ),
                  ) : SizedBox(height: 0.0)
                ],
              ),
            ),
          ),
        ]
    );
  }
}
