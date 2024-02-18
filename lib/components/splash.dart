import 'dart:async';
import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:flutter/widgets.dart';
import '../services/ignition.dart';
import 'app.dart';
import 'basic/logo.dart';
import 'basic/spacer.dart';
import 'theme/animation_durations.dart';
import 'theme/colors.dart';
import 'theme/text_theme.dart';

class RuiSplash extends StatefulWidget {
  const RuiSplash({
    super.key,
  });

  @override
  State<RuiSplash> createState() => _RuiSplashState();
}

class _RuiSplashState extends State<RuiSplash> {
  bool ready = RuiIgnition.ready;

  @override
  void initState() {
    super.initState();
    RuiIgnition.initialize(() async {
      if (!mounted) return;
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      setState(() {
        ready = true;
      });
    });
  }

  Widget buildSplash(
    final BuildContext context, {
    required final Color foregroundColor,
  }) =>
      SizedBox.expand(
        child: DefaultTextStyle(
          style: RuiTextTheme.standard.headline,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RuiLogo(size: 75, color: foregroundColor),
              RuiSpacer.verticalRelaxed,
              const _RuiSplashLoadingIndicator(),
            ],
          ),
        ),
      );

  @override
  Widget build(final BuildContext context) {
    final Brightness systemThemeMode = RuiApp.systemThemeMode;
    final Color foregroundColor = switch (systemThemeMode) {
      Brightness.light => RuiColors.black,
      Brightness.dark => RuiColors.white,
    };
    final Color backgroundColor = switch (systemThemeMode) {
      Brightness.light => RuiColors.light100,
      Brightness.dark => RuiColors.dark900,
    };
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: backgroundColor,
        child: PageTransitionSwitcher(
          duration: RuiAnimationDurations.slow,
          transitionBuilder: (
            final Widget child,
            final Animation<double> animation,
            final Animation<double> secondaryAnimation,
          ) =>
              FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            fillColor: backgroundColor,
            child: child,
          ),
          child: ready
              ? const RuiApp()
              : buildSplash(context, foregroundColor: foregroundColor),
        ),
      ),
    );
  }
}

class _RuiSplashLoadingIndicator extends StatefulWidget {
  const _RuiSplashLoadingIndicator();

  @override
  State<_RuiSplashLoadingIndicator> createState() =>
      __RuiSplashLoadingIndicatorState();
}

class __RuiSplashLoadingIndicatorState
    extends State<_RuiSplashLoadingIndicator> {
  bool highlight = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 500), (final _) {
      if (!mounted) return;
      setState(() {
        highlight = !highlight;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    timer = null;
  }

  @override
  Widget build(final BuildContext context) => Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: highlight ? RuiColors.blue500 : RuiColors.dark800,
        ),
      );
}
