import 'package:flutter/material.dart';
import 'package:hebrew_dictionary/Pages/MainPage.dart';
import 'package:hebrew_dictionary/Pages/TestDetailsPage.dart';
import 'package:hebrew_dictionary/Pages/TestResultPage.dart';
import 'package:hebrew_dictionary/Pages/TestSettingsPage.dart';
import 'package:hebrew_dictionary/Pages/TestingPage.dart';
import 'package:hebrew_dictionary/Settings/Settings.dart';
import 'package:hebrew_dictionary/WorkWithData/DatabaseManager.dart';
import 'package:hebrew_dictionary/WorkWithData/Dictionary.dart';
import 'package:provider/provider.dart';

import 'WorkWithData/Note.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Settings settings = Settings();
  await settings.initSettings();
  DatabaseManager db = DatabaseManager();
  await db.initDB();
  Dictionary engDict = Dictionary<English>();
  Dictionary hebDict = Dictionary<Hebrew>();
  await db.getDict(English()).then((value) => engDict.initDict(value));
  await db.getDict(Hebrew()).then((value) => hebDict.initDict(value));
  runApp(MultiProvider(
      providers: [
        ListenableProvider<DatabaseManager>.value(value: db),
        ListenableProvider<Dictionary<English>>.value(value: engDict),
        ListenableProvider<Dictionary<Hebrew>>.value(value: hebDict),
        ListenableProvider<Settings>.value(value: settings),
      ],
      child: MyApp()),
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
      routes: {
        TestDetailsPage.route : (context) => TestDetailsPage()
      },
    );
  }
}
