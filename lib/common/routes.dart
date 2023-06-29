import 'package:flutter/material.dart';

import '../modules/main/main_module.dart';
import '../modules/home/routes/routes.dart';
import '../modules/cloud/routes/routes.dart';

export '../modules/main/main_module.dart';
export '../modules/home/routes/routes.dart';
export '../modules/cloud/routes/routes.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  MainModule.route: (context) => const MainPage(),
}
  ..addAll(homeRoutesMap)
  ..addAll(cloudRoutesMap);
