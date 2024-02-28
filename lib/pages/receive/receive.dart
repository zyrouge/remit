import 'package:flutter/widgets.dart';
import 'package:remit/exports.dart';
import '../../components/animations/fade_scale_transition2.dart';
import '../../components/basic/back_button.dart';
import '../../components/basic/scaffold.dart';
import '../../components/basic/spacer.dart';
import '../../components/localized.dart';
import '../../components/theme/animation_durations.dart';
import '../../components/theme/responsivity.dart';
import '../../components/theme/theme.dart';
import 'components/content.dart';
import 'components/exit_dialog.dart';

class RuiReceivePageOptions {
  const RuiReceivePageOptions({
    required this.receiver,
  });

  final RemitReceiver receiver;
}

class RuiReceivePage extends StatefulWidget {
  const RuiReceivePage({
    required this.options,
    super.key,
  });

  final RuiReceivePageOptions options;

  @override
  State<RuiReceivePage> createState() => _RuiReceivePageState();
}

class _RuiReceivePageState extends State<RuiReceivePage> {
  bool showBackDialog = false;
  bool canPop = false;

  @override
  void dispose() {
    super.dispose();
    receiver.destroy();
  }

  @override
  Widget build(final BuildContext context) {
    final RuiTheme theme = RuiTheme.of(context);
    return PopScope(
      canPop: canPop,
      onPopInvoked: (final bool didPop) {
        if (didPop) return;
        if (canPop) {
          Navigator.of(context).pop();
          return;
        }
        if (!showBackDialog) {
          setState(() {
            showBackDialog = true;
          });
        }
      },
      child: RuiScaffold(
        maxWidth: RuiResponsivity.md,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RuiSpacer.verticalRelaxed,
            RuiBackButton(
              onClick: () => Navigator.of(context).maybePop(),
            ),
            RuiSpacer.verticalCozy,
            Text(context.t.send, style: theme.textTheme.display),
            RuiSpacer.verticalCozy,
            RuiReceivePageContent(receiver: receiver),
            RuiSpacer.verticalCozy,
          ],
        ),
        overlays: <Widget>[
          AnimatedSwitcher(
            duration: RuiAnimationDurations.normal,
            transitionBuilder: (
              final Widget child,
              final Animation<double> animation,
            ) =>
                FadeScaleTransition2(
              animation: animation,
              alignment: Alignment.topCenter,
              child: child,
            ),
            child: showBackDialog
                ? RuiSendPageExitDialog(shouldExit: onExit)
                : null,
          ),
        ],
      ),
    );
  }

  void onExit(final bool exit) {
    if (exit) {
      setState(() {
        showBackDialog = false;
        canPop = true;
      });
      Navigator.of(context).maybePop();
    } else {
      setState(() {
        showBackDialog = false;
      });
    }
  }

  RemitReceiver get receiver => widget.options.receiver;
}
