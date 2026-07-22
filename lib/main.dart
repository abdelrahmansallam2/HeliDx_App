import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_colors.dart';
import 'l10n/app_localizations.dart';
import 'pages/splash_page.dart';

final ValueNotifier<Locale?> appLocale = ValueNotifier(null);

const _supportedLocales = [Locale('en'), Locale('ar')];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString('language_code');
  if (saved != null) {
    appLocale.value = Locale(saved);
  }
  runApp(const HeliDxApp());
}

class HeliDxApp extends StatelessWidget {
  const HeliDxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: appLocale,
      builder: (context, locale, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'HeliDx',
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: _supportedLocales,
          localeResolutionCallback: (locale, supportedLocales) {
            for (final supported in supportedLocales) {
              if (supported.languageCode == locale?.languageCode) {
                return supported;
              }
            }
            return const Locale('en');
          },
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.scaffold,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.seed,
              brightness: Brightness.dark,
            ),
          ),
          home: const SplashPage(),
        );
      },
    );
  }
}
