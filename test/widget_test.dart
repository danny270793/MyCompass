import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mycompass/core/di/injection.dart';
import 'package:mycompass/l10n/app_localizations.dart';
import 'package:mycompass/pages/settings_page.dart';
import 'package:mycompass/widgets/compass_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _host(Widget child, {Locale locale = const Locale('en')}) => MaterialApp(
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    setupDi();
  });

  testWidgets('compass dial paints', (tester) async {
    await tester.pumpWidget(
      _host(
        const Scaffold(
          body: CompassDial(
            heading: 42,
            targetBearing: 90,
            cardinals: ['N', 'E', 'S', 'W'],
          ),
        ),
      ),
    );
    expect(find.byType(CompassDial), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('settings shows compass, appearance and security', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const SettingsPage()));
    await tester.pumpAndSettle();
    expect(find.text('Coordinate format'), findsOneWidget);
    expect(find.text('Haptic feedback'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Face ID & fingerprint'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Face ID & fingerprint'), findsOneWidget);
  });

  testWidgets('settings is translated to Spanish', (tester) async {
    await tester.pumpWidget(
      _host(const SettingsPage(), locale: const Locale('es')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ajustes'), findsOneWidget);
    expect(find.text('Formato de coordenadas'), findsOneWidget);
  });
}
