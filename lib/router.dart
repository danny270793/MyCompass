import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'pages/home_page.dart';
import 'pages/legal_info_page.dart';
import 'pages/settings_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
      routes: [
        GoRoute(
          path: 'about',
          builder: (context, state) =>
              const LegalInfoPage(kind: LegalInfoKind.about),
        ),
        GoRoute(
          path: 'privacy',
          builder: (context, state) =>
              const LegalInfoPage(kind: LegalInfoKind.privacy),
        ),
        GoRoute(
          path: 'terms',
          builder: (context, state) =>
              const LegalInfoPage(kind: LegalInfoKind.terms),
        ),
      ],
    ),
  ],
);
