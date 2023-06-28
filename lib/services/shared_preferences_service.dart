import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:u_vet_classifyer/common/extensions.dart';

enum SharePrefsAttribute {
  itsFirstTime,
  token,
  refreshToken,
}

class SharedPreferencesService {
  /// singleton boilerplate
  static final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService._internal();

  factory SharedPreferencesService() {
    return _sharedPreferencesService;
  }

  SharedPreferencesService._internal();
  /// singleton boilerplate

  late SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;

  Future initialize() async => _prefs = await SharedPreferences.getInstance();

  /// CHECK IF IT'S FIRST TIME
  bool getItsFirstTime() => prefs.getBool(SharePrefsAttribute.itsFirstTime.name.toShortString()) ?? true;

  void setItsFirstTime(bool value) {
    prefs.setBool(SharePrefsAttribute.itsFirstTime.name.toShortString(), value);
  }

  /// USER DATA
  String? getToken() {
    String? token = prefs.getString(SharePrefsAttribute.token.name.toShortString());
    return token;
  }
  void setToken(String token) {
    prefs.setString(SharePrefsAttribute.token.name.toShortString(), token);
  }
  void removeToken() {
    prefs.remove(SharePrefsAttribute.token.name.toShortString());
    _removeRefreshToken();
  }

  String? getRefreshToken() {
    String? token = prefs.getString(SharePrefsAttribute.refreshToken.name.toShortString());
    return token;
  }
  void setRefreshToken(String token) {
    prefs.setString(SharePrefsAttribute.refreshToken.name.toShortString(), token);
  }
  void _removeRefreshToken() {
    prefs.remove(SharePrefsAttribute.refreshToken.name.toShortString());
  }
}
