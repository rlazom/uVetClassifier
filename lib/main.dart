import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:u_vet_classifyer/common/themes.dart';
import 'package:u_vet_classifyer/services/navigation_service.dart';

import 'common/providers.dart';
import 'common/routes.dart';
import 'l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    const String title = 'uVetClassifier';
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: title,
        theme: theme,
        supportedLocales: const [
          Locale('en'),
          Locale('de'),
        ],
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          if (locale == null) {
            return supportedLocales.first;
          }
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        routes: routes,
        initialRoute: MainModule.route,
        navigatorKey: NavigationService().navigatorKey,
      ),
    );
  }
}