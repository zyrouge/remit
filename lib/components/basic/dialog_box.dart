import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../theme/color_scheme.dart';
import '../theme/theme.dart';
import 'spacer.dart';

class RuiDialogBoxStyle {
  const RuiDialogBoxStyle({
    required this.color,
    this.width = defaultWidth,
    this.padding = defaultPadding,
    this.bodyPadding = defaultBodyPadding,
    this.borderRadius = defaultBorderRadius,
    this.height,
    this.strokeColor,
  });

  factory RuiDialogBoxStyle.standard(
    final BuildContext context, {
    final double? width,
    final double? height,
    final EdgeInsets? padding,
    final EdgeInsets? bodyPadding,
    final BorderRadius? borderRadius,
  }) {
    final RuiColorScheme colorScheme = RuiTheme.colorSchemeOf(context);
    return RuiDialogBoxStyle(
      color: colorScheme.background,
      strokeColor: colorScheme.backgroundVariant,
      width: width ?? defaultWidth,
      height: height,
      padding: padding ?? defaultPadding,
      bodyPadding: bodyPadding ?? defaultBodyPadding,
      borderRadius: borderRadius ?? defaultBorderRadius,
    );
  }

  final double width;
  final double? height;
  final EdgeInsets padding;
  final EdgeInsets bodyPadding;
  final BorderRadius borderRadius;
  final Color color;
  final Color? strokeColor;

  static const BorderRadius defaultBorderRadius =
      BorderRadius.all(Radius.circular(8));

  static const EdgeInsets defaultPadding = EdgeInsets.all(8);
  static const EdgeInsets defaultBodyPadding =
      EdgeInsets.symmetric(horizontal: 8);
  static const double defaultWidth = 320;
}

class RuiDialogBox extends StatelessWidget {
  const RuiDialogBox({
    required this.style,
    required this.body,
    this.title,
    this.actions,
    super.key,
  });

  final RuiDialogBoxStyle style;
  final Widget body;
  final Widget? title;
  final List<Widget>? actions;

  @override
  Widget build(final BuildContext context) => Container(
        width: style.width,
        height: style.height,
        padding: style.padding,
        decoration: BoxDecoration(
          color: style.color,
          borderRadius: style.borderRadius,
          border: style.strokeColor != null
              ? Border.all(color: style.strokeColor!)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (title != null) ...<Widget>[
              RuiSpacer.verticalCompact,
              Padding(
                padding: style.bodyPadding,
                child: DefaultTextStyle(
                  style: RuiTheme.of(context).textTheme.title,
                  child: title!,
                ),
              ),
              RuiSpacer.verticalNormal,
            ],
            Padding(
              padding: style.bodyPadding,
              child: body,
            ),
            RuiSpacer.verticalRelaxed,
            if (actions != null) Row(children: actions!),
          ],
        ),
      );
}
