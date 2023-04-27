import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iasi_ar/provider/app_locale.dart';
import 'package:iasi_ar/screens/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iasi_ar/service_locator.dart';
import 'package:provider/provider.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppLocale(),
      child: Consumer<AppLocale>(builder: (context, locale, child) {
        return MaterialApp(
          title: 'Inside Iași',
          localizationsDelegates:
              AppLocalizations.localizationsDelegates, // important
          supportedLocales: AppLocalizations.supportedLocales, //
          locale: locale.locale,
          theme: ThemeData(
              brightness: Brightness.dark,
              textTheme:
                  GoogleFonts.latoTextTheme(Theme.of(context).textTheme)),
          debugShowCheckedModeBanner: false,
          home: const MyHomePage(title: 'Point of interest detection AR'),
        );
      }),
    );
  }
}
