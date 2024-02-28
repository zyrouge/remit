import 'package:flutter/widgets.dart';
import '../../../components/basic/button.dart';
import '../../../components/basic/dialog_box.dart';
import '../../../components/basic/spacer.dart';
import '../../../components/localized.dart';

class RuiSendPageExitDialog extends StatelessWidget {
  const RuiSendPageExitDialog({
    required this.shouldExit,
  });

  final void Function(bool) shouldExit;

  @override
  Widget build(final BuildContext context) => RuiDialogBox(
        style: RuiDialogBoxStyle.standard(context),
        title: Text(context.t.exitQuestion),
        body: Text(context.t.serverExitMessage),
        actions: <Widget>[
          Expanded(
            child: RuiButton(
              style: RuiButtonStyle.outlined(),
              onClick: () => shouldExit(false),
              child: Text(context.t.cancel),
            ),
          ),
          RuiSpacer.horizontalCompact,
          Expanded(
            child: RuiButton(
              style: RuiButtonStyle.error(),
              onClick: () => shouldExit(true),
              child: Text(context.t.exit),
            ),
          ),
        ],
      );
}
