import 'package:flutter/widgets.dart';
import '../../../components/basic/button.dart';
import '../../../components/basic/dialog_box.dart';
import '../../../components/basic/spacer.dart';
import '../../../components/localized.dart';
import '../send.dart';

class RuiSendPageConnectionRequestDialog extends StatelessWidget {
  const RuiSendPageConnectionRequestDialog({
    required this.pair,
  });

  final RuiSendPageConnectionRequestPair pair;

  @override
  Widget build(final BuildContext context) => RuiDialogBox(
        style: RuiDialogBoxStyle.standard(context),
        body: Text('${pair.info.username} is requesting connection'),
        actions: <Widget>[
          Expanded(
            child: RuiButton(
              style: RuiButtonStyle.outlined(),
              onClick: () => pair.completer.complete(false),
              child: Text(context.t.deny),
            ),
          ),
          RuiSpacer.horizontalCompact,
          Expanded(
            child: RuiButton(
              style: RuiButtonStyle.primary(),
              onClick: () => pair.completer.complete(true),
              child: Text(context.t.accept),
            ),
          ),
        ],
      );
}
