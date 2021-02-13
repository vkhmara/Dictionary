import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  bool showFloatButton = false;
  List<Note> _dict;
  FocusNode _focusNode;
  int mode = 0;
  static String _foundWord = '';
  ScrollController _controller;
  static const int ALL = 0;
  static const int ONLY_LEARNED = 1;
  static const int ONLY_UNLEARNED = 2;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = ScrollController();
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
      case ONLY_LEARNED:
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
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.search),
              SizedBox(
                child: TextField(
                  focusNode: _focusNode,
                  onChanged: (s) {
                    setState(() {
                      _foundWord = s;
                    });
                  },
                ),
                width: 130.0,
              ),
              ElevatedButton(
                  child: Text(['Все', 'Выуч', 'Невыуч'][mode]),
                  onPressed: () {
                    setState(() {
                      mode = (mode + 1) % 3;
                    });
                  }
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_up),
                    onPressed: () {
                      _controller.animateTo(_controller.position.minScrollExtent,
                          duration: Duration(milliseconds: 2500),
                          curve: Curves.ease);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_down),
                    onPressed: () {
                      _controller.animateTo(_controller.position.maxScrollExtent,
                          duration: Duration(milliseconds: 2500),
                          curve: Curves.ease);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        backgroundColor: Color(0x20FFFFFF),
      ),
      body: Scrollbar(
        child: ListView(
          controller: _controller,
          children: notes,
        ),
      ),
      floatingActionButton: Visibility(
        visible: showFloatButton,
        child: FloatingActionButton(
          child: Icon(Icons.keyboard_arrow_down_sharp),
          onPressed: () {
            _controller.animateTo(_dict.length * 50.0, duration: Duration(milliseconds: 500),
                curve: Curves.ease);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }
}
