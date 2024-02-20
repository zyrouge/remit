import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import '../../../components/basic/button.dart';
import '../../../components/basic/icon.dart';
import '../../../components/basic/spacer.dart';
import '../../../components/basic/text_field.dart';

class RuiSettingsTextField extends StatefulWidget {
  const RuiSettingsTextField({
    required this.value,
    required this.onChanged,
    this.validate,
  });

  final String value;
  final String? Function(String)? validate;
  final void Function(String) onChanged;

  @override
  State<RuiSettingsTextField> createState() => __RuiStateSettingsTextField();
}

class __RuiStateSettingsTextField extends State<RuiSettingsTextField> {
  late final TextEditingController controller;
  bool hasChanged = false;

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
  Widget build(final BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: RuiTextField(
              style: RuiTextFieldStyle.outlined(context),
              controller: controller,
              validate: widget.validate,
              onChanged: (final _) => onChanged(),
              onFinished: (final _) => onFinished(),
            ),
          ),
          RuiSpacer.horizontalTight,
          RuiButton(
            style: RuiButtonStyle.primary(),
            enabled: hasChanged,
            onClick: onFinished,
            child: const RuiIcon(Ionicons.checkmark_sharp),
          ),
          RuiSpacer.horizontalTight,
          RuiButton(
            style: RuiButtonStyle.surface(),
            enabled: hasChanged,
            onClick: reset,
            child: const RuiIcon(Ionicons.refresh_outline),
          ),
        ],
      );

  void onChanged() {
    setState(() {
      hasChanged = isValid && value != widget.value;
    });
  }

  void onFinished() {
    if (!isValid) return;
    widget.onChanged(value);
    controller.text = value;
    setState(() {
      hasChanged = false;
    });
  }

  void reset() {
    controller.text = widget.value;
    onChanged();
  }

  String get value => controller.text.trim();
  bool get isValid => widget.validate?.call(value) == null;
}
