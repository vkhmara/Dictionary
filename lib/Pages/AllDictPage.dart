import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hebrew_dictionary/HelperComponents/NoteInDict.dart';
import 'package:hebrew_dictionary/Settings/Settings.dart';
import 'package:hebrew_dictionary/WorkWithData/Dictionary.dart';
import 'package:hebrew_dictionary/WorkWithData/Language.dart';
import 'package:hebrew_dictionary/WorkWithData/Note.dart';
import 'package:provider/provider.dart';

class AllDictPage extends StatefulWidget {
  @override
  _AllDictPageState createState() => _AllDictPageState();
}

class _AllDictPageState extends State<AllDictPage> {
  List<Note> _dict;
  FocusNode _focusNode;
  static String _foundWord = '';
  int mode = 0;
  static const int ALL = 0;
  static const int ONLY_LEARNT = 1;
  static const int ONLY_UNLEARNED = 2;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  void unfocus() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    if (settings.language.runtimeType == Hebrew) {
      _dict = Provider.of<Dictionary<Hebrew>>(context).find(_foundWord);
    }
    else {
      _dict = Provider.of<Dictionary<English>>(context).find(_foundWord);
    }
    switch (mode) {
      case ONLY_LEARNT:
        {
          _dict.removeWhere((note) => note.learnt == false);
          break;
        }
      case ONLY_UNLEARNED:
        {
          _dict.removeWhere((note) => note.learnt == true);
          break;
        }
    }
    List<Widget> notes = _dict.map((e) => NoteInDict(e, unfocus)).toList();
    if (notes.isEmpty) {
      notes = [Container(
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('В данной категории отсутствуют слова')
          ],
        ),
      )];
    }
    return Scrollbar(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.search),
                SizedBox(
                  child: TextField(
                    focusNode: _focusNode,
                    autofocus: false,
                    onChanged: (s) {
                      setState(() {
                        _foundWord = s;
                      });
                    },
                  ),
                  width: 150.0,
                ),
                RaisedButton(
                  color: Colors.white,
                    child: Text(mode == ALL ? 'Все' : (mode == ONLY_LEARNT ? 'Выуч': 'Невыуч') ),
                    onPressed: () {
                      setState(() {
                        mode = (mode + 1) % 3;
                      });
                    })
              ],
            ),
          )
        ]
          ..addAll(notes),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
