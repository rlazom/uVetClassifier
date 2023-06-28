

import '../modules/main/main_module.dart';
import '../modules/home/home_module.dart';

export '../modules/main/main_module.dart';
export '../modules/home/home_module.dart';

final routes = {
  MainModule.route: (context) => const MainPage(),
  HomeModule.route: (context) => HomePage(viewModel: HomeViewModel()),
};
