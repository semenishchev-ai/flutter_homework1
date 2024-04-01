import 'package:flutter/material.dart';
import 'package:homework1/screens/home_page.dart';
import 'package:homework1/utils/riverpod_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLightTheme = ref.watch(themeProvider);
    final String locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Flutter News App',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(locale),
      debugShowCheckedModeBanner: false,
      theme: isLightTheme ? ThemeData.light() : ThemeData.dark(),
      home: const HomePage(),
    );
  }
}
