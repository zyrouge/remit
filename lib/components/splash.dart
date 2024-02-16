import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/assets.dart';
import '../services/ignition.dart';
import 'app.dart';
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
    RuiIgnition.initialize(() {
      if (!mounted) return;
      setState(() {
        ready = true;
      });
    });
  }

  Widget buildSplash(final BuildContext context) => Directionality(
        textDirection: TextDirection.ltr,
        child: ColoredBox(
          color: RuiColors.dark900,
          child: DefaultTextStyle(
            style: RuiTextTheme.standard.headline,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  RuiImageAssets.logoTransparent,
                  width: 75,
                ),
                const SizedBox(height: 20),
                const _RuiSplashLoadingIndicator(),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(final BuildContext context) {
    if (!ready) {
      return buildSplash(context);
    }
    return const RuiApp();
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
