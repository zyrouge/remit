import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:remit/exports.dart';
import '../../components/animations/fade_scale_transition2.dart';
import '../../components/basic/back_button.dart';
import '../../components/basic/button.dart';
import '../../components/basic/dialog_box.dart';
import '../../components/basic/scaffold.dart';
import '../../components/basic/spacer.dart';
import '../../components/localized.dart';
import '../../components/theme/animation_durations.dart';
import '../../components/theme/responsivity.dart';
import '../../components/theme/theme.dart';
import '../../utils/async_result.dart';
import '../../utils/device.dart';
import '../../utils/log.dart';
import 'start.dart';

class RuiSendPageOptions {
  const RuiSendPageOptions({
    required this.host,
    required this.username,
    required this.port,
    required this.acceptMode,
    required this.secure,
  });

  final String host;
  final String username;
  final int port;
  final RuiConnectionAcceptModes acceptMode;
  final bool secure;
}

class RuiSendPage extends StatefulWidget {
  const RuiSendPage({
    required this.options,
    super.key,
  });

  final RuiSendPageOptions options;

  @override
  State<RuiSendPage> createState() => _RuiSendPageState();
}

class _RuiConnectionRequestPair {
  const _RuiConnectionRequestPair({
    required this.address,
    required this.info,
    required this.completer,
  });

  final RemitConnectionAddress address;
  final RemitReceiverBasicInfo info;
  final Completer<bool> completer;
}

class _RuiSendPageState extends State<RuiSendPage> {
  RuiAsyncResult<RemitSender, Object> sender = RuiAsyncResult.waiting();
  final List<_RuiConnectionRequestPair> requests =
      <_RuiConnectionRequestPair>[];
  bool showBackDialog = false;
  bool canPop = false;

  @override
  void initState() {
    super.initState();
    initSender();
  }

  @override
  void dispose() {
    super.dispose();
    sender.asSuccessOrNull?.value.destroy();
  }

  Future<void> initSender() async {
    sender = RuiAsyncResult.processing();
    try {
      final String? device = await getDeviceName();
      final RemitSender value = await RemitSender.create(
        info: RemitSenderBasicInfo(
          username: widget.options.username,
          device: device,
        ),
        address: RemitConnectionAddress(widget.options.host, 0),
        secure: widget.options.secure,
        logger: log,
        onConnectionRequest: ({
          required final RemitConnectionAddress receiverAddress,
          required final RemitReceiverBasicInfo receiverInfo,
        }) async {
          final Completer<bool> completer = Completer<bool>();
          final _RuiConnectionRequestPair request = _RuiConnectionRequestPair(
            address: receiverAddress,
            info: receiverInfo,
            completer: completer,
          );
          setState(() {
            requests.add(request);
          });
          return completer.future;
        },
      );
      if (!mounted) {
        value.destroy();
        return;
      }
      setState(() {
        sender = RuiAsyncResult.success(value);
      });
    } catch (error) {
      setState(() {
        sender = RuiAsyncResult.failed(error);
      });
    }
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
        scrollableBody: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RuiSpacer.verticalRelaxed,
            RuiBackButton(
              onClick: () => Navigator.of(context).maybePop(),
            ),
            RuiSpacer.verticalCozy,
            Text('hi'),
            RuiSpacer.verticalCozy,
          ],
        ),
        overlays: <Widget>[
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: RuiAnimationDurations.normal,
              child: showBackDialog || requests.isNotEmpty
                  ? ModalBarrier(
                      dismissible: false,
                      color:
                          theme.colorScheme.backgroundVariant.withOpacity(0.25),
                    )
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
            child: showBackDialog
                ? _RuiExitDialog(
                    shouldExit: (final bool exit) {
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
                    },
                  )
                : requests.isNotEmpty
                    ? _RuiConnectionRequestDialog(pair: requests.first)
                    : null,
          ),
        ],
      ),
    );
  }
}

class _RuiExitDialog extends StatelessWidget {
  const _RuiExitDialog({
    required this.shouldExit,
  });

  final void Function(bool) shouldExit;

  @override
  Widget build(final BuildContext context) => RuiDialogBox(
        style: RuiDialogBoxStyle.standard(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(context.t.doYouReallyWantToStopSharingFiles),
            RuiSpacer.verticalNormal,
            Row(
              children: <Widget>[
                Expanded(
                  child: RuiButton(
                    style: RuiButtonStyle.outlined(),
                    onClick: () => shouldExit(false),
                    child: Text(context.t.no),
                  ),
                ),
                RuiSpacer.horizontalCompact,
                Expanded(
                  child: RuiButton(
                    style: RuiButtonStyle.primary(),
                    onClick: () => shouldExit(true),
                    child: Text(context.t.yes),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class _RuiConnectionRequestDialog extends StatelessWidget {
  const _RuiConnectionRequestDialog({
    required this.pair,
  });

  final _RuiConnectionRequestPair pair;

  @override
  Widget build(final BuildContext context) => RuiDialogBox(
        style: RuiDialogBoxStyle.standard(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('${pair.info.username} is requesting connection'),
            RuiSpacer.verticalNormal,
            Row(
              children: <Widget>[
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
            ),
          ],
        ),
      );
}
