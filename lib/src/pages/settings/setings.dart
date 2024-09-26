import 'package:flutter/material.dart';
// import 'package:islamic_educators/controller/theme_controller.dart';
// import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeNotifier>(context);
    final width = MediaQuery.sizeOf(context).width;

    final fontSize = width * 0.015;

    return Column(
      children: [
        // SwitchListTile(
        //   activeColor: Theme.of(context).primaryColor,
        //   activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.5),
        //   trackColor: themeProvider.isDarkMode
        //       ? WidgetStateProperty.all(
        //           Theme.of(context).primaryColor.withOpacity(0.5))
        //       : WidgetStateColor.transparent,
        //   inactiveTrackColor: WidgetStateColor.transparent,
        //   inactiveThumbColor: Colors.grey,
        //   trackOutlineColor: themeProvider.isDarkMode
        //       ? WidgetStateProperty.all(Colors.transparent)
        //       : WidgetStateProperty.all(Colors.grey),
        //   title: Text(
        //     'Dark Mode',
        //     style: TextStyle(
        //       color: Theme.of(context).colorScheme.onSecondaryContainer,
        //       fontSize: fontSize,
        //     ),
        //   ),
        //   value: themeProvider.isDarkMode,
        //   onChanged: (bool value) {
        //     themeProvider.toggleTheme();
        //   },
        //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // )
        Text('Settings Screen'),
      ],
    );
  }
}
