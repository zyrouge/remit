import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../components/basic/back_button.dart';
import '../components/basic/scaffold.dart';
import '../components/basic/spacer.dart';
import '../components/basic/text_field.dart';
import '../components/theme/responsivity.dart';
import '../components/theme/theme.dart';
import '../services/settings/settings.dart';

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
    return RuiScaffold(
      maxWidth: RuiResponsivity.md,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RuiSpacer.verticalRelaxed,
          RuiBackButton(
            onClick: () {
              Navigator.of(context).pop();
            },
          ),
          RuiSpacer.verticalCozy,
          Text(
            'Settings',
            style: RuiTheme.textThemeOf(context).headline,
          ),
          RuiSpacer.verticalRelaxed,
          Text('Username'),
          RuiSpacer.verticalTight,
          _RuiSettingsTextField(
            value: settings.username ?? 'demo-user',
            onChanged: (final String value) {
              RuiSettings.update(settings.copyWith(username: value));
            },
          ),
        ],
      ),
    );
  }
}

class _RuiSettingsTextField extends StatefulWidget {
  const _RuiSettingsTextField({
    required this.value,
    required this.onChanged,
  });

  final String value;
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
        style: RuiTextFieldStyle.standard(context),
        controller: controller,
        onChanged: (final _) {},
        onFinished: (final String value) {
          if (value == widget.value) return;
          widget.onChanged(value);
        },
      );
}
