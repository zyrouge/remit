import 'package:flutter/widgets.dart';

import '../components/basic/scaffold.dart';

class RuiHomePage extends StatefulWidget {
  const RuiHomePage({
    super.key,
  });

  @override
  State<RuiHomePage> createState() => _RuiHomePageState();
}

class _RuiHomePageState extends State<RuiHomePage> {
  @override
  Widget build(final BuildContext context) => RuiScaffold(body: Text('hi'));
}
