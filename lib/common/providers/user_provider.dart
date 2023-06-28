import 'package:flutter/foundation.dart' show ChangeNotifier, debugPrint;
import 'package:collection/collection.dart' show IterableExtension;

import '../../model/user.dart';

class UserProvider with ChangeNotifier {
  User? _user = User();
  bool biometricAuth = false;
  int servicesToReload = 0;
  int servicesReloaded = 0;

  User? get user => _user;
  bool get isLoggedIn => _user != null && _user!.id != null && _user!.token != null && _user!.token != '';

  void setUser(User? user, {bool forceFetchData = false}) {
    _user = user;
    notifyListeners();
    if(forceFetchData) {
      // fetchRemoteData();
    }
  }

  void clearUser({bool forceFetch = true}) {
    _user = null;
    notifyListeners();
    if (forceFetch) {
      // fetchRemoteData();
    }
  }

  _checkAllReloaded(String moduleStatus, int current, int total) {
    debugPrint('UserProvider - fetchRemoteData() - $moduleStatus - $current/$total - FINISHED');
    if (current == total) {
      debugPrint('UserProvider - fetchRemoteData() - ALL!!! - FINISHED');
    }
  }

  void setServicesToReload(int value) {
    servicesToReload = value;
    notifyListeners();
  }
  void setServiceReloaded() {
    servicesReloaded = servicesReloaded + 1;
    notifyListeners();
  }
  void resetLoading() {
    servicesToReload = 0;
    servicesReloaded = 0;
  }
}