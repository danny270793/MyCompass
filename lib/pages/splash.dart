import 'dart:async';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mycompass/pages/home.dart';
import 'package:mycompass/pages/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  static String get path => '/splash';

  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final LocalAuthentication localAuthentication = LocalAuthentication();

  Future<void> checkPermissions() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final bool useFingerprint =
        sharedPreferences.getBool(SettingsPage.useFingerprintKey) ?? false;
    if (await localAuthentication.canCheckBiometrics && useFingerprint) {
      while (await localAuthentication.authenticate(
          localizedReason: 'Please authenticate to continue') ==
          false) {}
      if (mounted) {
        Navigator.popAndPushNamed(context, HomePage.path);
      }
    } else {
      if (mounted) {
        Navigator.popAndPushNamed(context, HomePage.path);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
