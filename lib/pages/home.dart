import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import '../components/basic/button.dart';
import '../components/basic/icon.dart';
import '../components/basic/scaffold.dart';
import '../components/basic/spacer.dart';
import '../components/basic/vertical_content.dart';
import '../components/localized.dart';
import '../components/theme/theme.dart';
import '../services/assets.dart';

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RuiVerticalContent(
            leading: SvgPicture.asset(
              RuiImageAssets.logoTransparent,
              width: 32,
            ),
            child: Text(
              'Remit',
              style: RuiTheme.of(context).textTheme.headline,
            ),
          ),
          RuiSpacer.verticalTight,
          Text(
            'Choose a below option when you are ready.',
            style: DefaultTextStyle.of(context)
                .style
                .copyWith(color: RuiTheme.of(context).colorScheme.dimmed),
          ),
          const RuiSpacer.vertical(24),
          RuiButton(
            theme: RuiButtonTheme.primary(width: buttonWidth),
            child: RuiVerticalContent(
              leading: const RuiIcon(Ionicons.share_outline),
              child: Text(context.t.send),
            ),
            onClick: () {},
          ),
          RuiSpacer.verticalTight,
          RuiButton(
            theme: RuiButtonTheme.primary(width: buttonWidth),
            child: RuiVerticalContent(
              leading: const RuiIcon(Ionicons.download_outline),
              child: Text(context.t.receive),
            ),
            onClick: () {},
          ),
          RuiSpacer.verticalTight,
          RuiButton(
            theme: RuiButtonTheme.surface(width: buttonWidth),
            child: RuiVerticalContent(
              leading: const RuiIcon(Ionicons.settings_outline),
              child: Text(context.t.settings),
            ),
            onClick: () {},
          ),
        ],
      ),
    );
  }
}
