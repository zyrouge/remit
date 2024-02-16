import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../pages/home.dart';
import '../services/settings/settings.dart';
import 'theme/color_scheme.dart';
import 'theme/text_theme.dart';
import 'theme/theme.dart';
import 'theme/theme_data.dart';

class RuiApp extends StatefulWidget {
  const RuiApp({
    super.key,
  });

  @override
  State<RuiApp> createState() => _RuiAppState();
}

class _RuiAppState extends State<RuiApp> {
  late RuiSettingsData settings;
  late RuiThemeData theme;

  @override
  void initState() {
    super.initState();
    updateSettings(RuiSettings.settings);
    RuiSettings.onSettingsChange = (final RuiSettingsData nSettings) {
      if (!mounted) return;
      updateSettings(nSettings);
    };
  }

  @override
  void dispose() {
    super.dispose();
    RuiSettings.onSettingsChange = null;
  }

  @override
  Widget build(final BuildContext context) => RuiTheme(
        data: theme,
        child: Provider<RuiSettingsData>.value(
          value: settings,
          child: WidgetsApp(
            textStyle: theme.textTheme.body,
            color: theme.colorScheme.background,
            builder: (final _, final __) => const RuiHomePage(),
          ),
        ),
      );

  void updateSettings(final RuiSettingsData nSettings) {
    settings = nSettings;
    theme = RuiThemeData(
      colorScheme: switch (settings.themeMode) {
        RuiThemeMode.light => RuiColorScheme.light,
        RuiThemeMode.dark => RuiColorScheme.dark,
      },
      textTheme: RuiTextTheme.standard,
    );
  }
}
