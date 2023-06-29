import 'package:flutter/material.dart';

import '../modules/main/main_module.dart';
import '../modules/home/routes/routes.dart';

export '../modules/main/main_module.dart';
export '../modules/home/routes/routes.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  MainModule.route: (context) => const MainPage(),
}..addAll(homeRoutesMap);
