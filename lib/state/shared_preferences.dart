import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String isLoggedInKey = 'isLoggedIn';

  static Future<void> setLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLoggedInKey, value);
  }

  // static Future<bool> isLoggedIn() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getBool(isLoggedInKey) ?? false;
  // }
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedInValue = prefs.getBool(isLoggedInKey);

    return isLoggedInValue ?? false;
  }
}
