import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hebrew_dictionary/Pages/AddWordPage.dart';
import 'package:hebrew_dictionary/Pages/AllDictPage.dart';
import 'package:hebrew_dictionary/Pages/TestSettingsPage.dart';
import 'package:hebrew_dictionary/Settings/Settings.dart';
import 'package:hebrew_dictionary/WorkWithData/Note.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Словарь'),
            PopupMenuButton(
              child: Text('Язык'),
              onSelected: (point) {
                Settings settings = Provider.of<Settings>(context);
                if (point == 'eng') {
                  setState(() {
                    settings.language = English();
                  });
                }
                else {
                  setState(() {
                    settings.language = Hebrew();
                  });
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                    child: Text('Английский'),
                  value: 'eng',
                ),
                PopupMenuItem(
                    child: Text('Иврит'),
                  value: 'heb'
                ),
              ],
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Весь словарь'),
              onTap: () {
                setState(() {
                  currentPage = 0;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: Text('Добавить слово'),
              onTap: () {
                setState(() {
                  currentPage = 1;
                  Navigator.pop(context);
                });
              },
            ),
          ListTile(
              title: Text('Тест'),
              onTap: () {
                setState(() {
                  currentPage = 2;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
      body: ((page) {
        switch (page) {
          case 0:
            return AllDictPage();
          case 1:
            return AddWordPage();
          case 2:
            return TestSettingsPage();
        }
      })(currentPage),
      backgroundColor: Color(0xF0F0F0F0),
    );
  }
  void toMainPage() {
    setState(() {
      currentPage = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
