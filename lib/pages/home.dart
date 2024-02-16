import 'package:flutter/widgets.dart';
import '../components/basic/button.dart';
import '../components/basic/scaffold.dart';
import '../components/localized.dart';

class RuiHomePage extends StatefulWidget {
  const RuiHomePage({
    super.key,
  });

  @override
  State<RuiHomePage> createState() => _RuiHomePageState();
}

class _RuiHomePageState extends State<RuiHomePage> {
  @override
  Widget build(final BuildContext context) => RuiScaffold(
        body: Column(
          children: <Widget>[
            RuiButton(
              theme: RuiButtonTheme.primary(),
              child: Text(context.t.send),
              onClick: () {},
            ),
            RuiButton(
              theme: RuiButtonTheme.primary(),
              child: Text(context.t.receive),
              onClick: () {},
            ),
          ],
        ),
      );
}
