import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  static String get path => '/settings';
  static String useFingerprintKey = 'use-fingerprint';

  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool useFingerprint = false;
  bool isLoading = true;
  AdaptiveThemeMode? adaptiveThemeMode;

  getAsyncData() async {
    adaptiveThemeMode = await AdaptiveTheme.getThemeMode();
    final sharedPreferences = await SharedPreferences.getInstance();
    useFingerprint =
        sharedPreferences.getBool(SettingsPage.useFingerprintKey) ?? false;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAsyncData();
    super.initState();
  }

  Future<void> setNewTheme(final String theme) async {
    if (theme == 'light') {
      AdaptiveTheme.of(context).setLight();
    } else if (theme == 'dark') {
      AdaptiveTheme.of(context).setDark();
    } else if (theme == 'system-defined') {
      AdaptiveTheme.of(context).setSystem();
    }

    adaptiveThemeMode = await AdaptiveTheme.getThemeMode();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  String themeToString() {
    if (adaptiveThemeMode!.isSystem) {
      return 'System defined';
    } else if (adaptiveThemeMode!.isDark) {
      return 'Dark';
    } else if (adaptiveThemeMode!.isLight) {
      return 'Light';
    } else {
      return 'Invalid theme';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Appearance'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.format_paint),
                title: const Text('Theme'),
                value: Text(themeToString()),
                onPressed: (final BuildContext context) {
                  showModalBottomSheet(
                      context: context,
                      builder: (final BuildContext context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text('System defined'),
                            selected: adaptiveThemeMode!.isSystem,
                            onTap: () =>
                                setNewTheme('system-defined'),
                          ),
                          ListTile(
                            title: const Text('Dark'),
                            selected: adaptiveThemeMode!.isDark,
                            onTap: () => setNewTheme('dark'),
                          ),
                          ListTile(
                            title: const Text('Light'),
                            selected: adaptiveThemeMode!.isLight,
                            onTap: () => setNewTheme('light'),
                          ),
                        ],
                      ));
                },
              ),
            ],
          ),
          SettingsSection(title: const Text('Security'), tiles: [
            SettingsTile.switchTile(
              onToggle: (final bool value) async {
                final SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
                sharedPreferences.setBool(
                    SettingsPage.useFingerprintKey, value);
                setState(() {
                  useFingerprint = value;
                });
              },
              initialValue: useFingerprint,
              leading: const Icon(Icons.fingerprint),
              title: const Text('Use biometrics'),
              description: const Text('Request biometrics to login'),
            ),
          ])
        ],
      ),
    );
  }
}
