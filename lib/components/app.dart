import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../pages/home.dart';
import '../services/settings/settings.dart';
import '../services/translations/translation.dart';
import '../services/translations/translations.dart';
import 'localized.dart';
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
  RuiTranslation translation = defaultTranslation;

  @override
  void initState() {
    super.initState();
    updateSettings(RuiSettings.settings);
    RuiSettings.onSettingsChange = (final RuiSettingsData nSettings) {
      if (!mounted) return;
      setState(() {
        updateSettings(nSettings);
      });
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
        child: RuiLocalized(
          data: translation,
          child: MultiProvider(
            providers: <Provider<dynamic>>[
              Provider<RuiSettingsData>.value(value: settings),
            ],
            child: WidgetsApp(
              textStyle: theme.textTheme.body,
              color: theme.colorScheme.background,
              builder: (final _, final __) => const RuiHomePage(),
            ),
          ),
        ),
      );

  void updateSettings(final RuiSettingsData nSettings) {
    settings = nSettings;
    theme = RuiThemeData(
      colorScheme: switch (nSettings.themeMode) {
        RuiThemeMode.light => RuiColorScheme.light,
        RuiThemeMode.dark => RuiColorScheme.dark,
      },
      textTheme: RuiTextTheme.standard,
    );
    updateTranslation(nSettings);
  }

  Future<void> updateTranslation(final RuiSettingsData nSettings) async {
    final String nLocale = nSettings.locale ?? kDefaultLocaleCode;
    if (nLocale == translation.localeCode) return;
    final RuiTranslation nTranslation = await RuiTranslations.resolve(nLocale);
    if (!mounted) return;
    setState(() {
      translation = nTranslation;
    });
  }
}
