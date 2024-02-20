import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:remit/exports.dart';
import '../../components/basic/back_button.dart';
import '../../components/basic/button.dart';
import '../../components/basic/dropdown.dart';
import '../../components/basic/scaffold.dart';
import '../../components/basic/spacer.dart';
import '../../components/localized.dart';
import '../../components/theme/responsivity.dart';
import '../../components/theme/theme.dart';
import '../../utils/list.dart';
import '../../utils/result.dart';
import '../settings/components/field.dart';
import '../settings/components/username_text_field.dart';

enum RuiConnectionAcceptModes {
  ask,
  allowAll;

  String toLocalizedString(final BuildContext context) => switch (this) {
        ask => context.t.ask,
        allowAll => context.t.allowAll,
      };
}

class RuiSendConfigurationPage extends StatefulWidget {
  const RuiSendConfigurationPage({
    super.key,
  });

  @override
  State<RuiSendConfigurationPage> createState() =>
      _RuiSendConfigurationPageState();
}

class _RuiSendConfigurationPageState extends State<RuiSendConfigurationPage> {
  RuiAsyncResult<List<InternetAddress>, Object> availableAddresses =
      RuiAsyncResult.waiting();

  String? host;
  RuiConnectionAcceptModes acceptMode = RuiConnectionAcceptModes.ask;
  bool secure = true;

  @override
  void initState() {
    super.initState();
    fetchAvailableAddresses();
  }

  Future<void> fetchAvailableAddresses() async {
    try {
      availableAddresses = RuiAsyncResult.processing();
      availableAddresses = RuiAsyncResult.success(
        await RemitServer.getAvailableNetworks(),
      );
    } catch (error) {
      availableAddresses = RuiAsyncResult.failed(error);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final RuiTheme theme = RuiTheme.of(context);
    return RuiScaffold(
      maxWidth: RuiResponsivity.md,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RuiSpacer.verticalRelaxed,
            Align(
              alignment: Alignment.topLeft,
              child: RuiBackButton(
                onClick: () => Navigator.of(context).pop(),
              ),
            ),
            RuiSpacer.verticalCozy,
            Text(context.t.settings, style: theme.textTheme.display),
            RuiSpacer.verticalCozy,
            const RuiUsernameSettingsTextField(),
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
            RuiSpacer.verticalCozy,
          ],
        ),
      ),
    );
  }
}
