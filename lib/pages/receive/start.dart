import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:remit/exports.dart';
import '../../components/app.dart';
import '../../components/basic/back_button.dart';
import '../../components/basic/button.dart';
import '../../components/basic/circular_loading_indicator.dart';
import '../../components/basic/dropdown.dart';
import '../../components/basic/horizontal_content.dart';
import '../../components/basic/icon.dart';
import '../../components/basic/interactive.dart';
import '../../components/basic/scaffold.dart';
import '../../components/basic/spacer.dart';
import '../../components/basic/text_field.dart';
import '../../components/localized.dart';
import '../../components/theme/animation_durations.dart';
import '../../components/theme/responsivity.dart';
import '../../components/theme/states.dart';
import '../../components/theme/theme.dart';
import '../../services/settings/settings.dart';
import '../../utils/async_result.dart';
import '../../utils/device.dart';
import '../../utils/extensions.dart';
import '../../utils/list.dart';
import '../../utils/log.dart';
import '../../utils/random_names.dart';
import '../settings/components/field.dart';
import 'receive.dart';

class RuiReceiveStartPage extends StatefulWidget {
  const RuiReceiveStartPage({
    super.key,
  });

  @override
  State<RuiReceiveStartPage> createState() => _RuiReceiveStartPageState();
}

class _RuiReceiveStartPageState extends State<RuiReceiveStartPage> {
  String? host;
  late final TextEditingController usernameTextController;
  late final TextEditingController portTextController;
  late final TextEditingController inviteCodeTextController;

  late final String defaultUsername;
  RuiAsyncResult<List<InternetAddress>, Object> availableAddresses =
      RuiAsyncResult.waiting();
  bool isConnecting = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    final RuiSettingsData settings = context.read();
    defaultUsername = settings.username ?? RuiRandomNames.generate();
    usernameTextController = TextEditingController(text: defaultUsername);
    portTextController = TextEditingController();
    inviteCodeTextController = TextEditingController();
    fetchAvailableAddresses();
  }

  @override
  void dispose() {
    super.dispose();
    usernameTextController.dispose();
    portTextController.dispose();
    inviteCodeTextController.dispose();
  }

  Future<void> fetchAvailableAddresses() async {
    setState(() {
      host = null;
      availableAddresses = RuiAsyncResult.processing();
    });
    try {
      final List<InternetAddress> value =
          await RemitServer.getAvailableNetworks();
      if (!mounted) {
        return;
      }
      setState(() {
        host = value.firstOrNull?.address;
        availableAddresses = RuiAsyncResult.success(value);
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        availableAddresses = RuiAsyncResult.failed(error);
      });
    }
  }

  Future<void> startConnecting() async {
    setState(() {
      isConnecting = true;
    });
    try {
      final String? device = await getDeviceName();
      final RemitReceiver receiver = await RemitReceiver.create(
        info: RemitReceiverBasicInfo(
          username: usernameTextController.text,
          device: device,
        ),
        address: RemitConnectionAddress(host!, 0),
        senderAddress: RemitConnectionAddress(
          host!,
          int.parse(portTextController.text),
        ),
        inviteCode: inviteCodeTextController.text,
        logger: log,
        onFilesystemUpdated: (final _) {
          // TODO: handle update event
          if (!mounted) {
            return;
          }
        },
      );
      if (!mounted) {
        receiver.destroy();
        return;
      }
      Navigator.of(context).pushNamed(
        RuiApp.receive,
        arguments: RuiReceivePageOptions(receiver: receiver),
      );
      setState(() {
        isConnecting = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      log.error('RemitReceiveStartPage', error.toString());
      setState(() {
        isConnecting = false;
        errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    final RuiTheme theme = RuiTheme.of(context);
    return RuiScaffold(
      maxWidth: RuiResponsivity.md,
      scrollableBody: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RuiSpacer.verticalRelaxed,
          RuiBackButton(
            onClick: () => Navigator.of(context).pop(),
          ),
          RuiSpacer.verticalCozy,
          Text(context.t.receive, style: theme.textTheme.display),
          RuiSpacer.verticalTight,
          Text(
            context.t.receiverConfigurationMessage,
            style: DefaultTextStyle.of(context)
                .style
                .copyWith(color: RuiTheme.colorSchemeOf(context).dimmed),
          ),
          RuiSpacer.verticalCozy,
          RuiSettingsField(
            label: context.t.username,
            child: RuiHorizontalContent(
              spacing: RuiSpacer.tightPx,
              trailing: RuiButton(
                enabled: usernameTextController.text != defaultUsername,
                style: RuiButtonStyle.surface(),
                onClick: () {
                  usernameTextController.text = defaultUsername;
                },
                child: const RuiIcon(Ionicons.refresh_sharp),
              ),
              child: Expanded(
                child: RuiTextField(
                  style: RuiTextFieldStyle.outlined(context),
                  controller: usernameTextController,
                  validate: validateUsername,
                  onChanged: (final _) => updateStates(),
                  onFinished: (final _) {},
                ),
              ),
            ),
          ),
          RuiSpacer.verticalRelaxed,
          RuiSettingsField(
            label: context.t.networkHost,
            child: RuiHorizontalContent(
              spacing: RuiSpacer.tightPx,
              trailing: RuiButton(
                enabled: !availableAddresses.isProcessing,
                style: RuiButtonStyle.surface(),
                onClick: fetchAvailableAddresses,
                child: const RuiIcon(Ionicons.refresh_sharp),
              ),
              child: Expanded(
                child: takeValue(
                  availableAddresses.asSuccessOrNull?.value ??
                      <InternetAddress>[],
                  (final List<InternetAddress> addresses) =>
                      RuiDropdown<String>(
                    enabled: addresses.isNotEmpty,
                    value: host ?? '',
                    labels: addresses.isEmpty
                        ? <String, String>{'': ''}
                        : addresses.associate(
                            (final InternetAddress x) =>
                                MapEntry<String, String>(
                              x.address,
                              '${x.address} (${x.type.name})',
                            ),
                          ),
                    style: RuiButtonStyle.outlined(),
                    popupStyle: RuiDropdownPopupStyle.standard(context),
                    itemStyle: RuiButtonStyle.text(),
                    onChanged: (final String value) {
                      setState(() {
                        host = value;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          RuiSpacer.verticalRelaxed,
          RuiSettingsField(
            label: context.t.networkPort,
            child: RuiTextField(
              style: RuiTextFieldStyle.outlined(context),
              type: TextInputType.number,
              controller: portTextController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              validate: validatePort,
              onChanged: (final _) => updateStates(),
              onFinished: (final _) {},
            ),
          ),
          RuiSpacer.verticalRelaxed,
          RuiSettingsField(
            label: context.t.inviteCode,
            child: RuiTextField(
              style: RuiTextFieldStyle.outlined(context),
              controller: inviteCodeTextController,
              validate: validateInviteCode,
              onChanged: (final _) => updateStates(),
              onFinished: (final _) {},
            ),
          ),
          RuiSpacer.verticalRelaxed,
          RuiButton(
            style: RuiButtonStyle(
              color: (
                final BuildContext context,
                final RuiInteractiveState state,
              ) {
                if (isConnecting) {
                  return theme.colorScheme.primaryVariant;
                }
                return theme.colorScheme.primaryWhenState(state.toThemeState());
              },
              textStyle: (
                final BuildContext context,
                final RuiInteractiveState state,
              ) {
                final TextStyle textStyle = DefaultTextStyle.of(context).style;
                final Color color = isConnecting
                    ? theme.colorScheme.onPrimaryVariant.withValues(alpha: 0.5)
                    : theme.colorScheme
                        .onPrimaryWhenState(state.toThemeState());
                return textStyle.copyWith(color: color);
              },
            ),
            enabled: validateAll() && !isConnecting,
            onClick: startConnecting,
            child: AnimatedSwitcher(
              duration: RuiAnimationDurations.fastest,
              child: !isConnecting
                  ? Text(context.t.connect)
                  : RuiHorizontalContent(
                      leading: RuiCircularLoadingIndicator(
                        style: RuiCircularLoadingIndicatorStyle(
                          foregroundColor: theme.colorScheme.onPrimaryVariant
                              .withValues(alpha: 0.5),
                          backgroundColor: theme.colorScheme.onPrimaryVariant
                              .withValues(alpha: 0.25),
                          size: DefaultTextStyle.of(context).style.fontSize! *
                              0.9,
                        ),
                      ),
                      child: Text(context.t.connecting),
                    ),
            ),
          ),
          if (errorMessage != null) ...<Widget>[
            RuiSpacer.verticalNormal,
            Text(
              context.t.couldntConnectMessage,
              style: DefaultTextStyle.of(context).style.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            RuiSpacer.verticalTight,
            Text(
              errorMessage!,
              style: DefaultTextStyle.of(context)
                  .style
                  .copyWith(color: theme.colorScheme.error),
            ),
          ],
          RuiSpacer.verticalCozy,
        ],
      ),
    );
  }

  String? validateUsername(final String value) {
    if (value.isNotEmpty && value.trim().length < 4) {
      return context.t.usernameTooShort;
    }
    return null;
  }

  String? validatePort(final String value) {
    if (value.isEmpty ||
        value != value.trim() ||
        (int.tryParse(value) ?? -1) < 0) {
      return context.t.invalidPortValue;
    }
    return null;
  }

  String? validateInviteCode(final String value) {
    if (value.isEmpty || value != value.trim()) {
      return context.t.invalidInviteCode;
    }
    return null;
  }

  bool validateAll() =>
      validateUsername(usernameTextController.text) == null &&
      validatePort(portTextController.text) == null &&
      validateInviteCode(inviteCodeTextController.text) == null &&
      host != null;

  void updateStates() {
    setState(() {});
  }
}
