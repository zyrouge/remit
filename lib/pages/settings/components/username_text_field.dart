import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../../components/localized.dart';
import '../../../services/settings/settings.dart';
import 'field.dart';
import 'text_field.dart';

class RuiUsernameSettingsTextField extends StatelessWidget {
  const RuiUsernameSettingsTextField({
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final RuiSettingsData settings = context.watch();
    return RuiSettingsField(
      label: context.t.username,
      child: RuiSettingsTextField(
        value: settings.username ?? '',
        validate: (final String value) => validate(context, value),
        onChanged: (final String value) {
          if (validate(context, value) != null) return;
          RuiSettings.update(settings.copyWith(username: value.trim()));
        },
      ),
    );
  }

  String? validate(final BuildContext context, final String value) {
    if (value.isNotEmpty && value.trim().length < 4) {
      return context.t.usernameTooShort;
    }
    return null;
  }
}
