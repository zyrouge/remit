import 'dart:io';

import 'package:flutter/widgets.dart';
import '../theme/animation_durations.dart';
import '../theme/color_scheme.dart';
import '../theme/states.dart';
import '../theme/theme.dart';
import 'interactive.dart';
import 'spacer.dart';

class RuiTextFieldStyle {
  const RuiTextFieldStyle({
    required this.textStyle,
    required this.color,
    required this.cursorColor,
    required this.inactiveCursorColor,
    required this.selectionColor,
    required this.padding,
    required this.borderRadius,
    this.strokeColor,
    this.height,
    this.width,
  });

  factory RuiTextFieldStyle.outlined(
    final BuildContext context, {
    final TextStyle? textStyle,
    final EdgeInsets? padding,
    final BorderRadius? borderRadius,
    final double? height,
    final double? width,
  }) {
    final RuiTheme theme = RuiTheme.of(context);
    return RuiTextFieldStyle(
      color: (final BuildContext context, final RuiInteractiveState state) =>
          RuiTheme.of(context)
              .colorScheme
              .backgroundWhenState(state.toThemeState()),
      strokeColor:
          (final BuildContext context, final RuiInteractiveState state) =>
              switch (state) {
        RuiInteractiveState.active ||
        RuiInteractiveState.hovered =>
          theme.colorScheme.surface,
        _ => theme.colorScheme.backgroundVariant,
      },
      textStyle: (final BuildContext context, final RuiInteractiveState state) {
        final RuiTheme theme = RuiTheme.of(context);
        final RuiColorScheme colorScheme = theme.colorScheme;
        final TextStyle nTextStyle =
            textStyle ?? DefaultTextStyle.of(context).style;
        final Color color =
            colorScheme.onBackgroundWhenState(state.toThemeState());
        return nTextStyle.copyWith(color: color);
      },
      cursorColor: theme.colorScheme.primary,
      inactiveCursorColor: theme.colorScheme.dimmed,
      selectionColor: theme.colorScheme.surface,
      padding: padding ?? defaultPadding,
      borderRadius: borderRadius ?? defaultBorderRadius,
      height: height,
      width: width,
    );
  }

  final RuiInteractiveStateCallback<TextStyle> textStyle;
  final RuiInteractiveStateCallback<Color> color;
  final RuiInteractiveStateCallback<Color>? strokeColor;
  final Color cursorColor;
  final Color inactiveCursorColor;
  final Color selectionColor;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final double? height;
  final double? width;

  static final BorderRadius defaultBorderRadius = BorderRadius.circular(8);
  static const EdgeInsets defaultPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 8);
}

class RuiTextField extends StatefulWidget {
  const RuiTextField({
    required this.style,
    required this.controller,
    required this.onChanged,
    required this.onFinished,
    this.type = TextInputType.text,
    this.enabled = true,
    this.validate,
    super.key,
  });

  final RuiTextFieldStyle style;
  final TextEditingController controller;
  final TextInputType type;
  final bool enabled;
  final String? Function(String)? validate;
  final void Function(String) onChanged;
  final void Function(String) onFinished;

  @override
  State<RuiTextField> createState() => _RuiTextFieldState();
}

class _RuiTextFieldState extends State<RuiTextField> {
  late final FocusNode focusNode;
  String? errorLabel;
  bool isHovered = false;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {
        isFocused = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  RuiInteractiveState toInteractiveState() {
    if (!widget.enabled) return RuiInteractiveState.disabled;
    if (isFocused) return RuiInteractiveState.active;
    if (isHovered) return RuiInteractiveState.hovered;
    return RuiInteractiveState.normal;
  }

  @override
  Widget build(final BuildContext context) {
    final RuiInteractiveState state = toInteractiveState();
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MouseRegion(
            onEnter: (final _) => updateHovered(true),
            onExit: (final _) => updateHovered(false),
            cursor: SystemMouseCursors.text,
            child: GestureDetector(
              onTap: widget.enabled ? focusNode.requestFocus : null,
              child: AnimatedContainer(
                duration: RuiAnimationDurations.fast,
                width: widget.style.width,
                height: widget.style.height,
                padding: widget.style.padding,
                decoration: BoxDecoration(
                  color: widget.style.color(context, state),
                  borderRadius: widget.style.borderRadius,
                  border: widget.style.strokeColor != null
                      ? Border.all(
                          color: widget.style.strokeColor!(context, state),
                        )
                      : null,
                ),
                child: AnimatedDefaultTextStyle(
                  duration: RuiAnimationDurations.fast,
                  style: widget.style.textStyle(context, state),
                  child: switch (widget.enabled) {
                    true => EditableText(
                        controller: widget.controller,
                        focusNode: focusNode,
                        style: DefaultTextStyle.of(context).style,
                        cursorWidth: 1,
                        cursorColor: widget.style.cursorColor,
                        backgroundCursorColor: widget.style.inactiveCursorColor,
                        selectionColor: widget.style.selectionColor,
                        keyboardType: widget.type,
                        showSelectionHandles:
                            Platform.isAndroid || Platform.isIOS,
                        selectionControls: _RuiTextSelectionControls(),
                        onChanged: updateTextChanged,
                        onSubmitted: widget.onFinished,
                        onTapOutside: (final _) => focusNode.unfocus(),
                      ),
                    false => Text(widget.controller.text),
                  },
                ),
              ),
            ),
          ),
          if (errorLabel != null) ...<Widget>[
            RuiSpacer.verticalCompact,
            Text(
              errorLabel!,
              style: RuiTheme.textThemeOf(context)
                  .small
                  .copyWith(color: RuiTheme.colorSchemeOf(context).error),
            ),
          ],
        ],
      ),
    );
  }

  void updateHovered(final bool value) {
    setState(() {
      isHovered = value;
    });
  }

  void updateTextChanged(final String value) {
    widget.onChanged(value);
    if (widget.validate == null) return;
    setState(() {
      errorLabel = widget.validate!(value);
    });
  }
}

class _RuiTextSelectionControls extends TextSelectionControls
    with TextSelectionHandleControls {
  @override
  Size getHandleSize(final double textLineHeight) =>
      const Size(handleSize, handleSize);

  @override
  Offset getHandleAnchor(
    final TextSelectionHandleType type,
    final double textLineHeight,
  ) =>
      switch (type) {
        TextSelectionHandleType.left => const Offset(handleSize / 2, 0),
        TextSelectionHandleType.right => const Offset(handleSize / 2, 0),
        // requires - 0.75px for some weird reason
        TextSelectionHandleType.collapsed =>
          const Offset((handleSize / 2) - 0.75, 0),
      };

  @override
  Widget buildHandle(
    final BuildContext context,
    final TextSelectionHandleType type,
    final double textHeight, [
    final VoidCallback? onTap,
  ]) {
    final RuiColorScheme colorScheme = RuiTheme.colorSchemeOf(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: handleSize,
        height: handleSize,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  static const double handleSize = 8;
}
