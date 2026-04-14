import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AppTheme { light, dark, sepia }

class SettingsProvider extends ChangeNotifier {
  AppTheme _theme = AppTheme.light;
  String _language = 'English';
  bool _dailyReminders = true;

  AppTheme get theme => _theme;
  String get language => _language;
  bool get dailyReminders => _dailyReminders;

  void setTheme(AppTheme theme) {
    _theme = theme;
    notifyListeners();
  }

  void setLanguage(String language) {
    _language = language;
    notifyListeners();
  }

  void toggleReminders(bool value) {
    _dailyReminders = value;
    notifyListeners();
  }

  ThemeData getThemeData() {
    switch (_theme) {
      case AppTheme.dark:
        return ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Colors.deepOrange,
            secondary: Colors.orangeAccent,
          ),
        );
      case AppTheme.sepia:
        return ThemeData.light().copyWith(
          scaffoldBackgroundColor: const Color(0xFFF4ECD8),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFE6D5B8),
            foregroundColor: Colors.black87,
          ),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF8B5A2B),
            secondary: Color(0xFFCD853F),
          ),
        );
      case AppTheme.light:
      default:
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        );
    }
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Personalization',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Theme'),
            trailing: DropdownButton<AppTheme>(
              value: provider.theme,
              onChanged: (AppTheme? newValue) {
                if (newValue != null) {
                  provider.setTheme(newValue);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: AppTheme.light,
                  child: Text('Light'),
                ),
                DropdownMenuItem(
                  value: AppTheme.dark,
                  child: Text('Dark'),
                ),
                DropdownMenuItem(
                  value: AppTheme.sepia,
                  child: Text('Sepia'),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: provider.language,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  provider.setLanguage(newValue);
                }
              },
              items: const [
                'English',
                'Hindi',
                'Sanskrit',
                'Bengali',
                'Gujarati',
                'Marathi'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('Daily Reminders'),
            subtitle: const Text('Remind me to chant daily'),
            value: provider.dailyReminders,
            onChanged: provider.toggleReminders,
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'About',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Version'),
            trailing: const Text('1.0.0'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
