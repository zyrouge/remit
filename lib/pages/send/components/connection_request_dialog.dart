import 'package:flutter/widgets.dart';
import '../../../components/basic/button.dart';
import '../../../components/basic/dialog_box.dart';
import '../../../components/basic/spacer.dart';
import '../../../components/localized.dart';
import '../send.dart';

class RuiSendPageConnectionRequestDialog extends StatelessWidget {
  const RuiSendPageConnectionRequestDialog({
    required this.pair,
    required this.shouldAccept,
  });

  final RuiSendPageConnectionRequestPair pair;
  final void Function(RuiSendPageConnectionRequestPair, bool) shouldAccept;

  @override
  Widget build(final BuildContext context) => RuiDialogBox(
        style: RuiDialogBoxStyle.standard(context),
        body: Text('${pair.info.username} is requesting connection'),
        actions: <Widget>[
          Expanded(
            child: RuiButton(
              style: RuiButtonStyle.outlined(),
              onClick: () => shouldAccept(pair, false),
              child: Text(context.t.deny),
            ),
          ),
          RuiSpacer.horizontalCompact,
          Expanded(
            child: RuiButton(
              style: RuiButtonStyle.primary(),
              onClick: () => shouldAccept(pair, true),
              child: Text(context.t.accept),
            ),
          ),
        ],
      );
}
