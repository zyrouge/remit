import 'package:flutter/widgets.dart';
import 'package:remit/exports.dart';
import '../../components/animations/fade_scale_transition2.dart';
import '../../components/basic/back_button.dart';
import '../../components/basic/modal_barrier.dart';
import '../../components/basic/scaffold.dart';
import '../../components/basic/spacer.dart';
import '../../components/localized.dart';
import '../../components/theme/animation_durations.dart';
import '../../components/theme/responsivity.dart';
import '../../components/theme/theme.dart';
import 'components/content.dart';
import 'components/exit_dialog.dart';
import 'components/queue_dialog.dart';

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
  late final RuiReceiverDownloadQueue queue;

  // -1 - none, 0 - exit, 1 - queue
  int showDialog = -1;
  bool canPop = false;

  @override
  void initState() {
    super.initState();
    queue = RuiReceiverDownloadQueue(widget.options.receiver);
  }

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
        if (showDialog != 0) {
          setState(() {
            showDialog = 0;
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
            Text(context.t.receive, style: theme.textTheme.display),
            RuiSpacer.verticalCozy,
            RuiReceivePageContent(
              receiver: receiver,
              queue: queue,
              toggleQueueDialog: () {
                setState(() {
                  showDialog = showDialog == 1 ? -1 : 1;
                });
              },
            ),
            RuiSpacer.verticalCozy,
          ],
        ),
        overlays: <Widget>[
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: RuiAnimationDurations.fastest,
              child: showDialog != -1
                  ? RuiModalBarrier(onDismiss: onDialogDismiss)
                  : null,
            ),
          ),
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
            child: showDialog == 0
                ? RuiReceivePageExitDialog(onDismiss: onExitDialogDismiss)
                : null,
          ),
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
            child: showDialog == 1 ? RuiReceivePageQueue(queue: queue) : null,
          ),
        ],
      ),
    );
  }

  void onExitDialogDismiss(final bool exit) {
    if (exit) {
      setState(() {
        showDialog = -1;
        canPop = true;
      });
      Navigator.of(context).maybePop();
      return;
    }
    onDialogDismiss();
  }

  void onDialogDismiss() {
    setState(() {
      showDialog = -1;
    });
  }

  RemitReceiver get receiver => widget.options.receiver;
}
