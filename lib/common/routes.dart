

import '../modules/home/view/home_page.dart';
import '../modules/home/view_model/home_view_model.dart';
import '../modules/main/main_module.dart';

export '../modules/main/main_module.dart';

final routes = {
  MainModule.route: (context) => const MainPage(),
  HomePage.route: (context) => HomePage(viewModel: HomeViewModel()),
};
