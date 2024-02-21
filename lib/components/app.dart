import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../pages/home.dart';
import '../pages/send/start.dart';
import '../pages/settings/settings.dart';
import '../services/settings/settings.dart';
import '../services/translations/translation.dart';
import '../services/translations/translations.dart';
import 'localized.dart';
import 'theme/animation_durations.dart';
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

  static const String home = '/';
  static const String settings = '/settings';
  static const String sendStart = '/send/start';
  static const String receive = '/receive';

  static Brightness get systemThemeMode =>
      SchedulerBinding.instance.platformDispatcher.platformBrightness;
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
              textStyle: theme.textTheme.body
                  .copyWith(color: theme.colorScheme.onBackground),
              color: theme.colorScheme.background,
              initialRoute: RuiApp.home,
              routes: <String, WidgetBuilder>{
                RuiApp.home: (final _) => const RuiHomePage(),
                RuiApp.settings: (final _) => const RuiSettingsPage(),
                RuiApp.sendStart: (final _) => const RuiSendStartPage(),
              },
              pageRouteBuilder: <T>(
                final RouteSettings settings,
                final WidgetBuilder builder,
              ) =>
                  PageRouteBuilder<T>(
                settings: settings,
                transitionDuration: RuiAnimationDurations.slow,
                pageBuilder: (
                  final BuildContext context,
                  final Animation<double> animation,
                  final Animation<double> secondaryAnimation,
                ) =>
                    SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal,
                  fillColor: theme.colorScheme.background,
                  child: builder(context),
                ),
              ),
            ),
          ),
        ),
      );

  void updateSettings(final RuiSettingsData nSettings) {
    settings = nSettings;
    theme = RuiThemeData(
      colorScheme: switch (nSettings.themeMode) {
        RuiThemeMode.system => switch (RuiApp.systemThemeMode) {
            Brightness.light => RuiColorScheme.light,
            Brightness.dark => RuiColorScheme.dark,
          },
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
