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

  @override
  Widget build(final BuildContext context) {
    if (!ready) {
      return Directionality(
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
  int highlight = 0;
  int count = 5;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 500), (final _) {
      if (!mounted) return;
      setState(() {
        highlight = (highlight + 1) % count;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    timer = null;
  }

  Widget buildSquare(final int target) => SizedBox(
        height: 2,
        width: 10,
        child: ColoredBox(
          color: highlight == target ? RuiColors.blue500 : RuiColors.dark800,
        ),
      );

  @override
  Widget build(final BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 0; i < count; i++) ...<Widget>[
            buildSquare(i),
            if (i != count - 1) const SizedBox(width: 2),
          ],
        ],
      );
}
