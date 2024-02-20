import 'package:flutter/widgets.dart';
import '../../../components/basic/spacer.dart';

class RuiSettingsField extends StatelessWidget {
  const RuiSettingsField({
    required this.label,
    required this.child,
    super.key,
  });

  final String label;
  final Widget child;

  @override
  Widget build(final BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label),
          RuiSpacer.verticalCompact,
          child,
        ],
      );
}
