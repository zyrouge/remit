import 'dart:async';
import 'package:flutter/widgets.dart';
import '../theme/color_scheme.dart';
import '../theme/theme.dart';
import 'icon.dart';
import 'spacer.dart';

class RuiSimpleMessageStyle {
  const RuiSimpleMessageStyle({
    required this.textStyle,
    required this.alignment,
    required this.textAlign,
    this.padding = defaultPadding,
  });

  factory RuiSimpleMessageStyle.standard(
    final BuildContext context, {
    final TextStyle? textStyle,
    final EdgeInsets? padding,
    final Alignment? alignment,
    final TextAlign? textAlign,
  }) =>
      RuiSimpleMessageStyle(
        textStyle: textStyle ?? DefaultTextStyle.of(context).style,
        padding: padding ?? defaultPadding,
        alignment: alignment ?? Alignment.centerLeft,
        textAlign: textAlign ?? TextAlign.left,
      );

  factory RuiSimpleMessageStyle.dimmed(
    final BuildContext context, {
    final TextStyle? textStyle,
    final EdgeInsets? padding,
    final Alignment? alignment,
    final TextAlign? textAlign,
  }) {
    final RuiColorScheme colorScheme = RuiTheme.colorSchemeOf(context);
    final TextStyle nTextStyle =
        textStyle ?? DefaultTextStyle.of(context).style;
    return RuiSimpleMessageStyle(
      textStyle: nTextStyle.copyWith(color: colorScheme.dimmed),
      padding: padding ?? defaultPadding,
      alignment: alignment ?? Alignment.center,
      textAlign: textAlign ?? TextAlign.center,
    );
  }

  final EdgeInsets padding;
  final Alignment alignment;
  final TextStyle textStyle;
  final TextAlign textAlign;

  static const EdgeInsets defaultPadding =
      EdgeInsets.symmetric(vertical: RuiSpacer.cozyPx);
}

class RuiSimpleMessage extends StatelessWidget {
  const RuiSimpleMessage({
    required this.child,
    required this.style,
    super.key,
  });

  RuiSimpleMessage.icon({
    required final IconData icon,
    required final TextSpan text,
    required this.style,
    super.key,
  }) : child = Text.rich(
          TextSpan(
            children: <InlineSpan>[
              WidgetSpan(child: RuiIcon(icon, color: style.textStyle.color)),
              const TextSpan(text: ' '),
              text,
            ],
            style: style.textStyle,
          ),
          textAlign: style.textAlign,
        );

  RuiSimpleMessage.loading({
    required final Widget text,
    required this.style,
    super.key,
  }) : child = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _RuiLoadingIndicator(),
            RuiSpacer.horizontalCompact,
            DefaultTextStyle(
              style: style.textStyle,
              textAlign: style.textAlign,
              child: text,
            ),
          ],
        );

  RuiSimpleMessage.text({
    required final String text,
    required this.style,
    super.key,
  }) : child = Text(
          text,
          style: style.textStyle,
          textAlign: style.textAlign,
        );

  final Widget child;
  final RuiSimpleMessageStyle style;

  @override
  Widget build(final BuildContext context) => Padding(
        padding: style.padding,
        child: Align(alignment: style.alignment, child: child),
      );
}

class _RuiLoadingIndicator extends StatefulWidget {
  const _RuiLoadingIndicator();

  @override
  State<_RuiLoadingIndicator> createState() => __RuiLoadingIndicatorState();
}

class __RuiLoadingIndicatorState extends State<_RuiLoadingIndicator> {
  bool highlight = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 500), (final _) {
      if (!mounted) {
        return;
      }
      setState(() {
        highlight = !highlight;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    timer = null;
  }

  @override
  Widget build(final BuildContext context) {
    final RuiColorScheme colorScheme = RuiTheme.colorSchemeOf(context);
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        color: highlight ? colorScheme.primary : colorScheme.backgroundVariant,
      ),
    );
  }
}
