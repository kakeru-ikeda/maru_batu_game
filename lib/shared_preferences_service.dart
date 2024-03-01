import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService._privateConstructor();

  static final SharedPreferencesService instance =
      SharedPreferencesService._privateConstructor();

  Future<SharedPreferences> get _instance async =>
      await SharedPreferences.getInstance();

  Future<List<String>?> getStringList(String key) async {
    final SharedPreferences prefs = await _instance;
    return prefs.getStringList(key);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    final SharedPreferences prefs = await _instance;
    return prefs.setStringList(key, value);
  }
}
