import 'package:flutter/widgets.dart';
import '../../../components/basic/button.dart';
import '../../../components/basic/dialog_box.dart';
import '../../../components/basic/spacer.dart';
import '../../../components/localized.dart';

class RuiReceivePageExitDialog extends StatelessWidget {
  const RuiReceivePageExitDialog({
    required this.onDismiss,
  });

  final void Function(bool) onDismiss;

  @override
  Widget build(final BuildContext context) => RuiDialogBox(
        style: RuiDialogBoxStyle.standard(context),
        title: Text(context.t.exitQuestion),
        body: Text(context.t.serverExitMessage),
        actions: <Widget>[
          Expanded(
            child: RuiButton(
              style: RuiButtonStyle.outlined(),
              onClick: () => onDismiss(false),
              child: Text(context.t.cancel),
            ),
          ),
          RuiSpacer.horizontalCompact,
          Expanded(
            child: RuiButton(
              style: RuiButtonStyle.error(),
              onClick: () => onDismiss(true),
              child: Text(context.t.exit),
            ),
          ),
        ],
      );
}
