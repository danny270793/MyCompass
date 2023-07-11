import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:mycompass/pages/home.dart';
import 'package:mycompass/pages/settings.dart';
import 'package:mycompass/pages/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  runApp(MyApp(adaptiveThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? adaptiveThemeMode;

  const MyApp({super.key, this.adaptiveThemeMode});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData.light(useMaterial3: true),
        dark: ThemeData.dark(useMaterial3: true),
        initial: adaptiveThemeMode ?? AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
              darkTheme: darkTheme,
              theme: theme,
              initialRoute: SplashPage.path,
              routes: {
                SplashPage.path: (context) => const SplashPage(),
                HomePage.path: (context) => const HomePage(),
                SettingsPage.path: (context) => const SettingsPage(),
              },
            ));
  }
}
