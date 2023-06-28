import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/providers/loader_state.dart';
import '../../../common/providers/user_provider.dart';
import '../../../services/db_service.dart';
import '../../home/view/home_page.dart';

class MainViewModel extends LoaderViewModel {
  final DbService dbService = DbService();
  late UserProvider userProvider;

  MainViewModel();

  @override
  loadData({BuildContext? context, bool forceReload = false}) async {
    userProvider = Provider.of<UserProvider>(navigator.context, listen: false);
    markAsLoading();
    List<Future> list = [
      sharedPreferencesService.initialize(),
      dbService.initialize(),
    ];
    await Future.wait(list);
    navigateTo();
  }

  navigateTo() {
    bool itsFirstTime = sharedPreferencesService.getItsFirstTime();
    if (itsFirstTime) {
      sharedPreferencesService.setItsFirstTime(false);
      // navigator.toRoute(OnBoardingPage.route, pushAndReplace: true);
      navigator.toRoute(HomePage.route, pushAndReplace: true);
    } else {
      navigator.toRoute(HomePage.route, pushAndReplace: true);
    }
  }
}
