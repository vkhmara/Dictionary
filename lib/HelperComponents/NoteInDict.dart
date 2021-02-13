import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hebrew_dictionary/Settings/Settings.dart';
import 'package:hebrew_dictionary/WorkWithData/DatabaseManager.dart';
import 'package:hebrew_dictionary/WorkWithData/Dictionary.dart';
import 'package:hebrew_dictionary/WorkWithData/Language.dart';
import 'package:hebrew_dictionary/WorkWithData/Note.dart';
import 'package:provider/provider.dart';

class NoteInDict extends StatefulWidget {
  final Note note;
  final void Function() unfocus;
  NoteInDict(this.note, this.unfocus);

  @override
  _NoteInDictState createState() => _NoteInDictState();
}

class _NoteInDictState extends State<NoteInDict> {
  Note newNote;
  TextEditingController tecTrans = TextEditingController();
  TextEditingController tecWord = TextEditingController();
  bool editMode = false;
  bool error = false;

  Widget editingNote(BuildContext context) {
    tecTrans.text = widget.note.translation.word;
    tecWord.text = widget.note.word.word;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 20.0,),
              SizedBox(
                child: TextField(
                  controller: tecTrans,
                  maxLength: 24,
                ),
                width: 140.0,
              ),
              SizedBox(
                child: TextField(
                  controller: tecWord,
                  maxLength: 24,
                ),
                width: 140.0,
              ),
              SizedBox(width: 20.0,),
            ],
          ),
          SizedBox(height: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                  error ? 'Неправильный ввод' : '',
                  style: TextStyle(
                    color: Colors.red
                  ),
              )
            ],
          ),
          SizedBox(height: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 50.0,
              ),
              RaisedButton(
                child: Text('OK'),
                onPressed: () async {
                  error = false;
                  newNote = Note.fromNote(widget.note);
                  try {
                    newNote.translation.word = tecTrans.text;
                    newNote.word.word = tecWord.text;
                  }
                  catch (e) {
                    setState(() {
                      error = true;
                    });
                    return;
                  }
                  Settings settings = Provider.of<Settings>(context);
                  if (!newNote.isValid() ||
                      newNote.word.word != widget.note.word.word && (
                          settings.language.runtimeType == Hebrew &&
                              Provider.of< Dictionary<Hebrew > >(context).contains(
                                  newNote.word) ||
                              settings.language.runtimeType == English &&
                                  Provider.of<Dictionary<English>>(context).contains(
                                      newNote.word))) {
                    setState(() {
                      error = true;
                    });
                    return;
                  }
                  await editNote(widget.note, newNote);
                  setState(() {
                    editMode = false;
                  });
                },
              ),
              RaisedButton(
                child: Text('Cancel'),
                onPressed: () {
                  error = false;
                  setState(() {
                    editMode = false;
                  });
                },
              ),
              SizedBox(
                width: 50.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (editMode) {
      return editingNote(context);
    }
    return Container(
      padding: widget.note.learnt ? EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0) :
      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      decoration: BoxDecoration(
          border: Border.all(width: 0.1),
          color: widget.note.learnt ? Color(0xA0CFCFCF) : Color(0xE0FFFFFF),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Checkbox(
                  value: widget.note.learnt,
                  onChanged: (bool value) async {
                    Note note = Note.fromNote(widget.note);
                    note.learnt = !note.learnt;
                    await editNote(widget.note, note);
                  },
                ),
                word(widget.note.translation.word),
              ],
            ),
          ),

          Container(
            child: Row(
              children: [
                word(widget.note.word.word),
                PopupMenuButton(
                    onSelected: _handleMenuAction,
                    itemBuilder: (context) =>
                    [
                      PopupMenuItem(
                        child: Text('Delete'),
                        value: 'Delete',
                      ),
                      PopupMenuItem(
                        child: Text('Edit'),
                        value: 'Edit',
                      ),
                    ]
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _handleMenuAction(String point) async {
    switch (point) {
      case 'Delete':
        {
          showDialog(
            context: context,
            builder: (_) =>
                AlertDialog(
                  content: Text(
                    'Are you sure?',
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        'Yes',
                        style: TextStyle(
                            fontSize: 20.0
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        'No',
                        style: TextStyle(
                            fontSize: 20.0
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ],
                ),
          ).then((toDelete) async {
            if (toDelete) {
              await deleteNote(widget.note);
            }
          });
          break;
        }
      case 'Edit':
        {
          setState(() {
            editMode = true;
          });
          break;
        }
    }
  }

  Future<void> editNote(Note oldNote, Note newNote) async {
    await Provider.of<DatabaseManager>(context).editNote(oldNote, newNote);
    Settings settings = Provider.of<Settings>(context);
    if (settings.language.runtimeType == Hebrew) {
      Provider.of<Dictionary<Hebrew>>(context).editNote(oldNote, newNote);
    }
    else {
      Provider.of<Dictionary<English>>(context).editNote(oldNote, newNote);
    }
  }

  Future<void> deleteNote(Note note) async {
    await Provider.of<DatabaseManager>(context).deleteNote(note);
    Settings settings = Provider.of<Settings>(context);
    if (settings.language.runtimeType == Hebrew) {
      Provider.of<Dictionary<Hebrew>>(context).deleteNote(note);
    }
    else {
      Provider.of<Dictionary<English>>(context).deleteNote(note);
    }

  }

  Widget word(String label) {
    return Text(
      label.replaceAll(' ', '\n'),
      style: TextStyle(
          fontSize: 19.0
      ),
    );
  }
}

