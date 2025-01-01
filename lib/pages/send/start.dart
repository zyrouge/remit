import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:remit/exports.dart';
import '../../components/app.dart';
import '../../components/basic/back_button.dart';
import '../../components/basic/button.dart';
import '../../components/basic/dropdown.dart';
import '../../components/basic/horizontal_content.dart';
import '../../components/basic/icon.dart';
import '../../components/basic/scaffold.dart';
import '../../components/basic/spacer.dart';
import '../../components/basic/text_field.dart';
import '../../components/localized.dart';
import '../../components/theme/responsivity.dart';
import '../../components/theme/theme.dart';
import '../../services/settings/settings.dart';
import '../../utils/async_result.dart';
import '../../utils/extensions.dart';
import '../../utils/list.dart';
import '../../utils/random_names.dart';
import '../settings/components/field.dart';
import 'send.dart';

enum RuiConnectionAcceptModes {
  ask,
  allowAll;

  String toLocalizedString(final BuildContext context) => switch (this) {
        ask => context.t.ask,
        allowAll => context.t.allowAll,
      };
}

class RuiSendStartPage extends StatefulWidget {
  const RuiSendStartPage({
    super.key,
  });

  @override
  State<RuiSendStartPage> createState() => _RuiSendStartPageState();
}

class _RuiSendStartPageState extends State<RuiSendStartPage> {
  String? host;
  late final TextEditingController usernameTextController;
  late final TextEditingController portTextController;
  RuiConnectionAcceptModes acceptMode = RuiConnectionAcceptModes.ask;
  bool secure = true;

  late final String defaultUsername;
  RuiAsyncResult<List<InternetAddress>, Object> availableAddresses =
      RuiAsyncResult.waiting();

  @override
  void initState() {
    super.initState();
    final RuiSettingsData settings = context.read();
    defaultUsername = settings.username ?? RuiRandomNames.generate();
    usernameTextController = TextEditingController(text: defaultUsername);
    portTextController = TextEditingController(text: defaultPort.toString());
    fetchAvailableAddresses();
  }

  @override
  void dispose() {
    super.dispose();
    usernameTextController.dispose();
    portTextController.dispose();
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
          Text(context.t.send, style: theme.textTheme.display),
          RuiSpacer.verticalTight,
          Text(
            context.t.senderConfigurationMessage,
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
            child: RuiHorizontalContent(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: RuiSpacer.tightPx,
              trailing: RuiButton(
                enabled: portTextController.text != defaultPort.toString(),
                style: RuiButtonStyle.surface(),
                onClick: () {
                  portTextController.text = defaultPort.toString();
                },
                child: const RuiIcon(Ionicons.refresh_sharp),
              ),
              child: Expanded(
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
            ),
          ),
          RuiSpacer.verticalRelaxed,
          RuiSettingsField(
            label: context.t.connectionAcceptMode,
            child: RuiDropdown<RuiConnectionAcceptModes>(
              value: acceptMode,
              labels: RuiConnectionAcceptModes.values.associateWith(
                (final RuiConnectionAcceptModes x) =>
                    x.toLocalizedString(context),
              ),
              style: RuiButtonStyle.outlined(),
              popupStyle: RuiDropdownPopupStyle.standard(context),
              itemStyle: RuiButtonStyle.text(),
              onChanged: (final RuiConnectionAcceptModes value) {
                setState(() {
                  acceptMode = value;
                });
              },
            ),
          ),
          RuiSpacer.verticalRelaxed,
          RuiSettingsField(
            label: context.t.secure,
            child: RuiDropdown<bool>(
              value: secure,
              labels: <bool, String>{
                true: context.t.yes,
                false: context.t.no,
              },
              style: RuiButtonStyle.outlined(),
              popupStyle: RuiDropdownPopupStyle.standard(context),
              itemStyle: RuiButtonStyle.text(),
              onChanged: (final bool value) {
                setState(() {
                  secure = value;
                });
              },
            ),
          ),
          RuiSpacer.verticalRelaxed,
          RuiButton(
            style: RuiButtonStyle.primary(),
            enabled: validateAll(),
            onClick: () => Navigator.of(context).pushNamed(
              RuiApp.send,
              arguments: RuiSendPageOptions(
                username: usernameTextController.text,
                host: host!,
                port: int.parse(portTextController.text),
                acceptMode: acceptMode,
                secure: secure,
              ),
            ),
            child: Text(context.t.start),
          ),
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

  bool validateAll() =>
      validateUsername(usernameTextController.text) == null &&
      validatePort(portTextController.text) == null &&
      host != null;

  void updateStates() {
    setState(() {});
  }

  static const int defaultPort = 0;
}
