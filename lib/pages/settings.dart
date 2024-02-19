import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../components/basic/back_button.dart';
import '../components/basic/button.dart';
import '../components/basic/dropdown.dart';
import '../components/basic/scaffold.dart';
import '../components/basic/spacer.dart';
import '../components/basic/text_field.dart';
import '../components/localized.dart';
import '../components/theme/responsivity.dart';
import '../components/theme/theme.dart';
import '../services/settings/settings.dart';
import '../utils/list.dart';

class RuiSettingsPage extends StatefulWidget {
  const RuiSettingsPage({
    super.key,
  });

  @override
  State<RuiSettingsPage> createState() => _RuiSettingsPageState();
}

class _RuiSettingsPageState extends State<RuiSettingsPage> {
  @override
  Widget build(final BuildContext context) {
    final RuiSettingsData settings = context.watch<RuiSettingsData>();
    final RuiTheme theme = RuiTheme.of(context);
    return RuiScaffold(
      maxWidth: RuiResponsivity.md,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RuiSpacer.verticalRelaxed,
            Align(
              alignment: Alignment.topLeft,
              child: RuiBackButton(
                onClick: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            RuiSpacer.verticalCozy,
            Text(context.t.settings, style: theme.textTheme.display),
            RuiSpacer.verticalCozy,
            Text(context.t.username),
            RuiSpacer.verticalTight,
            _RuiSettingsTextField(
              value: settings.username ?? '',
              validate: validateUsername,
              onChanged: (final String value) {
                if (validateUsername(value) != null) return;
                RuiSettings.update(settings.copyWith(username: value));
              },
            ),
            RuiSpacer.verticalRelaxed,
            Text(context.t.theme),
            RuiSpacer.verticalTight,
            RuiDropdown<RuiThemeMode>(
              value: settings.themeMode,
              labels: RuiThemeMode.values.associateWith(
                (final RuiThemeMode x) => x.toLocalizedString(context),
              ),
              style: RuiButtonStyle.outlined(),
              popupStyle: RuiDropdownPopupStyle.standard(context),
              itemStyle: RuiButtonStyle.text(),
              onChanged: (final RuiThemeMode value) {
                RuiSettings.update(settings.copyWith(themeMode: value));
              },
            ),
          ],
        ),
      ),
    );
  }

  String? validateUsername(final String value) {
    if (value.isNotEmpty && value.trim().length < 4) {
      return context.t.usernameTooShort;
    }
    return null;
  }
}

class _RuiSettingsTextField extends StatefulWidget {
  const _RuiSettingsTextField({
    required this.value,
    required this.onChanged,
    this.validate,
  });

  final String value;
  final String? Function(String)? validate;
  final void Function(String) onChanged;

  @override
  State<_RuiSettingsTextField> createState() => __RuiStateSettingsTextField();
}

class __RuiStateSettingsTextField extends State<_RuiSettingsTextField> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(final BuildContext context) => RuiTextField(
        style: RuiTextFieldStyle.outlined(context),
        controller: controller,
        validate: widget.validate,
        onChanged: widget.onChanged,
        onFinished: widget.onChanged,
      );
}
