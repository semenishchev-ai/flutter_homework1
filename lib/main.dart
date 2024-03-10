import 'package:flutter/material.dart';
import 'package:homework1/screens/home_page.dart';
import 'package:homework1/utils/notifiers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (context, isLightTheme, _) {
        return ValueListenableBuilder<Locale>(
          valueListenable: localeNotifier,
          builder: (context, locale, _) {
            return MaterialApp(
              title: 'Flutter News App',
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: locale,
              debugShowCheckedModeBanner: false,
              theme: isLightTheme ? ThemeData.light() : ThemeData.dark(),
              home: const HomePage(),
            );
          },
        );
      },
    );
  }
}
