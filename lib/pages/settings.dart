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

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  bool useFingerprint = false;
  bool isLoading = true;
  AdaptiveThemeMode? adaptiveThemeMode;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    getAsyncData();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  getAsyncData() async {
    adaptiveThemeMode = await AdaptiveTheme.getThemeMode();
    final sharedPreferences = await SharedPreferences.getInstance();
    useFingerprint =
        sharedPreferences.getBool(SettingsPage.useFingerprintKey) ?? false;
    setState(() {
      isLoading = false;
    });
    _fadeController.forward();
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

  IconData getThemeIcon() {
    if (adaptiveThemeMode!.isSystem) {
      return Icons.brightness_auto;
    } else if (adaptiveThemeMode!.isDark) {
      return Icons.dark_mode;
    } else if (adaptiveThemeMode!.isLight) {
      return Icons.light_mode;
    } else {
      return Icons.brightness_auto;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading settings...',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SettingsList(
                sections: [
                  SettingsSection(
                    title: Text(
                      'Appearance',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    tiles: <SettingsTile>[
                      SettingsTile.navigation(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            getThemeIcon(),
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        title: const Text('Theme'),
                        value: Text(
                          themeToString(),
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        onPressed: (final BuildContext context) {
                          _showThemeBottomSheet(context);
                        },
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: Text(
                      'Security',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    tiles: [
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
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.fingerprint,
                            color: theme.colorScheme.secondary,
                            size: 20,
                          ),
                        ),
                        title: const Text('Use biometrics'),
                        description: const Text('Request biometrics to login'),
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: Text(
                      'About',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    tiles: [
                      SettingsTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: theme.colorScheme.tertiary,
                            size: 20,
                          ),
                        ),
                        title: const Text('App Version'),
                        description: const Text('1.0.1+4'),
                      ),
                      SettingsTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.code,
                            color: theme.colorScheme.tertiary,
                            size: 20,
                          ),
                        ),
                        title: const Text('Developer'),
                        description: const Text('My Compass Team'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (final BuildContext context) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Choose Theme',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            ListTile(
              leading: Icon(
                Icons.brightness_auto,
                color: theme.colorScheme.primary,
              ),
              title: const Text('System defined'),
              subtitle: const Text('Follow system theme'),
              trailing: adaptiveThemeMode!.isSystem
                  ? Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.primary,
                    )
                  : null,
              onTap: () => setNewTheme('system-defined'),
            ),
            
            ListTile(
              leading: Icon(
                Icons.dark_mode,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Dark'),
              subtitle: const Text('Dark theme'),
              trailing: adaptiveThemeMode!.isDark
                  ? Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.primary,
                    )
                  : null,
              onTap: () => setNewTheme('dark'),
            ),
            
            ListTile(
              leading: Icon(
                Icons.light_mode,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Light'),
              subtitle: const Text('Light theme'),
              trailing: adaptiveThemeMode!.isLight
                  ? Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.primary,
                    )
                  : null,
              onTap: () => setNewTheme('light'),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}