import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyPrefs {
  static void putString(Keys key, String value) {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    _prefs.then((SharedPreferences prefs) {
      prefs.setString(key.toString(), value);
    });
  }

  static readObject(Keys key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(key.toString()) != null) {
      return json.decode(prefs.getString(key.toString()) ?? "");
    } else {
      return null;
    }
  }

  static void putDouble(Keys key, double value) {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    _prefs.then((SharedPreferences prefs) {
      prefs.setDouble(key.toString(), value);
    });
  }

  static void putBoolean(Keys key, bool value) {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    _prefs.then((SharedPreferences prefs) {
      prefs.setBool(key.toString(), value);
    });
  }

  static Future<String> getString(Keys key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var value = _prefs.getString(key.toString());
    if (value == null)
      return "";
    else
      return value;
  }

  static Future<double> getDouble(Keys key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var value = _prefs.getDouble(key.toString());
    if (value == null)
      return 0.0;
    else
      return value;
  }

  static Future<bool> getBoolean(Keys key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var value = _prefs.getBool(key.toString());
    if (value == null) if (key == Keys.IS_ENGLISH) {
      _prefs.setBool(key.toString(), value!);
      return true;
    } else
      return false;
    else
      return value;
  }

  static Future<bool> clearPref() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.clear();
  }

  static saveObject(Keys key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key.toString(), json.encode(value));
  }
}

enum Keys { USER_ID, TOKEN, FCM_TOKEN, LOGIN_DATA, IS_ENGLISH, EMAIL, PASSWORD, IS_REMEMBER_ME }
