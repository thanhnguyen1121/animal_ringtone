import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static setData(key, data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(data));
  }

  static getData(key, callBack) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);
    callBack(json.decode(value));
  }
}
