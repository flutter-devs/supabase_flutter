import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {

  static final AppPreference _appPreference = AppPreference._internal();

  factory AppPreference() {
    return _appPreference;
  }

  AppPreference._internal();

  late SharedPreferences _preferences;

  static const String token = 'token';
  static const String isLogged = 'is_logged';
  static const String publicKey = 'publicKey';
  static const String uuid = 'uuid';

  Future<void> initialAppPreference() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future setString(String key, String value) async {
    await _preferences.setString(key, value);
  }

  String getString(String key, {String defValue = ''}) {
    return _preferences.getString(key) ?? defValue;
  }

  Future setBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  bool getBool(String key, {bool defValue = false}) {
    return _preferences.getBool(key) ?? defValue;
  }

  Future<bool> setAuthToken(String value) async {
    return _preferences.setString(token, value);
  }

  String getAuthToken() {
    return _preferences.getString(token) ?? '';
  }

  Future<bool> isLoggedIn(String value) async {
    return _preferences.setString(isLogged, value);
  }
  String getLogged(String key) {
    return _preferences.getString(key)?? "No";
  }



  String getPin() {
    // var userId = FirebaseAuth.instance.currentUser!.uid;
    return _preferences.getString("Pin") ?? '';
  }



  Future clearPreferences() async {
    final preference = await SharedPreferences.getInstance();
    return await preference.clear();
  }
}
