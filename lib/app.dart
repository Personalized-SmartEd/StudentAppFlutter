import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smarted/feature/splash/splash_screen.dart';
import 'package:smarted/shared/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Flutter Demo',
      locale: const Locale('en'),
      debugShowCheckedModeBanner: false,
      theme: ZTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
