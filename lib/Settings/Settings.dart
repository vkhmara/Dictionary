import 'package:flutter/cupertino.dart';
import 'package:hebrew_dictionary/WorkWithData/Language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends ChangeNotifier{
  Language _language;

  Future<void> initSettings() async {
    SharedPreferences _sp = await SharedPreferences.getInstance();
    _language = Language.fromString(_sp.getString('lang'));
  }

  Language get language => _language;

  set language(Language value) {
    SharedPreferences.getInstance().then((_sp) {
      _sp.setString('lang', value.toString());
    });
    _language = value;
    notifyListeners();
  }

}