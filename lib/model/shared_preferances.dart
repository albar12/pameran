import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static Future<SharedPreferences> getPref() async =>
      await SharedPreferences.getInstance();

  static Future setString(String key, String value) async =>
      (await getPref()).setString(key, value);

  static Future setInt(String key, int value) async =>
      (await getPref()).setInt(key, value);

  static Future setBool(String key, bool value) async =>
      (await getPref()).setBool(key, value);

  static Future<String?> getString(String key) async =>
      (await getPref()).getString(key).toString();

  static Future<bool?> getBool(String key) async =>
      (await getPref()).getBool(key);
}
