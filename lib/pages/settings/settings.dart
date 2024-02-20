import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../components/basic/back_button.dart';
import '../../components/basic/button.dart';
import '../../components/basic/dropdown.dart';
import '../../components/basic/scaffold.dart';
import '../../components/basic/spacer.dart';
import '../../components/localized.dart';
import '../../components/theme/responsivity.dart';
import '../../components/theme/theme.dart';
import '../../services/settings/settings.dart';
import '../../services/translations/translations.dart';
import '../../utils/list.dart';
import 'components/field.dart';
import 'components/username_text_field.dart';

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
                onClick: () => Navigator.of(context).pop(),
              ),
            ),
            RuiSpacer.verticalCozy,
            Text(context.t.settings, style: theme.textTheme.display),
            RuiSpacer.verticalCozy,
            RuiSettingsField(
              label: context.t.language,
              child: RuiDropdown<String>(
                value: RuiLocalized.of(context).data.localeCode,
                labels: RuiTranslations.localeCodes.associateWith(
                  (final String x) {
                    final String display =
                        RuiTranslations.localeDisplayNames[x]!;
                    final String native = RuiTranslations.localeNativeNames[x]!;
                    if (display == native) {
                      return '$display ($x)';
                    }
                    return '$display / $native ($x)';
                  },
                ),
                style: RuiButtonStyle.outlined(),
                popupStyle: RuiDropdownPopupStyle.standard(context),
                itemStyle: RuiButtonStyle.text(),
                onChanged: (final String value) {
                  RuiSettings.update(settings.copyWith(locale: value));
                },
              ),
            ),
            RuiSpacer.verticalRelaxed,
            const RuiUsernameSettingsTextField(),
            RuiSpacer.verticalRelaxed,
            RuiSettingsField(
              label: context.t.theme,
              child: RuiDropdown<RuiThemeMode>(
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
            ),
            RuiSpacer.verticalCozy,
          ],
        ),
      ),
    );
  }
}
