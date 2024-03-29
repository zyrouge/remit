import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import '../components/app.dart';
import '../components/basic/button.dart';
import '../components/basic/horizontal_content.dart';
import '../components/basic/icon.dart';
import '../components/basic/logo.dart';
import '../components/basic/scaffold.dart';
import '../components/basic/spacer.dart';
import '../components/localized.dart';
import '../components/theme/responsivity.dart';
import '../components/theme/theme.dart';
import '../utils/meta.dart';

class RuiHomePage extends StatefulWidget {
  const RuiHomePage({
    super.key,
  });

  @override
  State<RuiHomePage> createState() => _RuiHomePageState();
}

class _RuiHomePageState extends State<RuiHomePage> {
  @override
  Widget build(final BuildContext context) {
    final double buttonWidth = min(200, MediaQuery.of(context).size.width);
    return RuiScaffold(
      maxWidth: RuiResponsivity.md,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RuiHorizontalContent(
            leading: const RuiLogo(size: 32),
            child: Text(
              RuiMeta.appName,
              style: RuiTheme.of(context).textTheme.headline,
            ),
          ),
          RuiSpacer.verticalCompact,
          Text(
            context.t.chooseABelowOptionWhenYouAreReady,
            style: DefaultTextStyle.of(context)
                .style
                .copyWith(color: RuiTheme.of(context).colorScheme.dimmed),
          ),
          RuiSpacer.verticalCozy,
          RuiButton(
            style: RuiButtonStyle.primary(width: buttonWidth),
            child: RuiHorizontalContent(
              leading: const RuiIcon(Ionicons.share_outline),
              child: Text(context.t.send),
            ),
            onClick: () => Navigator.of(context).pushNamed(RuiApp.sendStart),
          ),
          RuiSpacer.verticalCompact,
          RuiButton(
            style: RuiButtonStyle.primary(width: buttonWidth),
            child: RuiHorizontalContent(
              leading: const RuiIcon(Ionicons.download_outline),
              child: Text(context.t.receive),
            ),
            onClick: () => Navigator.of(context).pushNamed(RuiApp.receiveStart),
          ),
          RuiSpacer.verticalCompact,
          RuiButton(
            style: RuiButtonStyle.surface(width: buttonWidth),
            child: RuiHorizontalContent(
              leading: const RuiIcon(Ionicons.settings_outline),
              child: Text(context.t.settings),
            ),
            onClick: () {
              Navigator.of(context).pushNamed(RuiApp.settings);
            },
          ),
        ],
      ),
    );
  }
}
