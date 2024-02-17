import 'package:flutter/widgets.dart';
import '../theme/animation_durations.dart';
import '../theme/theme.dart';
import 'interactive.dart';

class RuiTextFieldStyle {
  const RuiTextFieldStyle({
    required this.textStyle,
    required this.color,
    required this.cursorColor,
    required this.inactiveCursorColor,
    required this.selectedColor,
    required this.padding,
    required this.borderRadius,
    this.strokeColor,
    this.height,
    this.width,
  });

  factory RuiTextFieldStyle.standard(
    final BuildContext context, {
    final EdgeInsets? padding,
    final BorderRadius? borderRadius,
    final double? height,
    final double? width,
  }) {
    final RuiTheme theme = RuiTheme.of(context);
    return RuiTextFieldStyle(
      textStyle: DefaultTextStyle.of(context).style,
      color: (final BuildContext context, final RuiInteractiveState state) =>
          switch (state) {
        RuiInteractiveState.active ||
        RuiInteractiveState.hovered =>
          theme.colorScheme.backgroundVariant,
        _ => theme.colorScheme.background,
      },
      strokeColor:
          (final BuildContext context, final RuiInteractiveState state) =>
              switch (state) {
        RuiInteractiveState.active ||
        RuiInteractiveState.hovered =>
          theme.colorScheme.surface,
        _ => theme.colorScheme.backgroundVariant,
      },
      cursorColor: theme.colorScheme.primary,
      inactiveCursorColor: theme.colorScheme.dimmed,
      selectedColor: theme.colorScheme.surface,
      padding: padding ?? defaultPadding,
      borderRadius: borderRadius ?? defaultBorderRadius,
      height: height,
      width: width,
    );
  }

  final TextStyle textStyle;
  final RuiInteractiveStateCallback<Color> color;
  final RuiInteractiveStateCallback<Color>? strokeColor;
  final Color cursorColor;
  final Color inactiveCursorColor;
  final Color selectedColor;
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
    super.key,
  });

  final RuiTextFieldStyle style;
  final TextEditingController controller;
  final TextInputType type;
  final bool enabled;
  final void Function(String) onChanged;
  final void Function(String) onFinished;

  @override
  State<RuiTextField> createState() => _RuiTextFieldState();
}

class _RuiTextFieldState extends State<RuiTextField> {
  late final FocusNode focusNode;
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
    return MouseRegion(
      onEnter: (final _) => updateHovered(true),
      onExit: (final _) => updateHovered(false),
      cursor: SystemMouseCursors.text,
      child: AnimatedContainer(
        duration: RuiAnimationDurations.fast,
        width: widget.style.width,
        height: widget.style.height,
        padding: widget.style.padding,
        decoration: BoxDecoration(
          color: widget.style.color(context, state),
          borderRadius: widget.style.borderRadius,
          border: widget.style.strokeColor != null
              ? Border.all(color: widget.style.strokeColor!(context, state))
              : null,
        ),
        child: EditableText(
          controller: widget.controller,
          focusNode: focusNode,
          style: widget.style.textStyle,
          cursorColor: widget.style.cursorColor,
          backgroundCursorColor: widget.style.inactiveCursorColor,
          selectionColor: widget.style.selectedColor,
          keyboardType: widget.type,
          onChanged: (final String value) => widget.onChanged(value),
          onSubmitted: (final String value) => widget.onFinished(value),
        ),
      ),
    );
  }

  void updateHovered(final bool value) {
    setState(() {
      isHovered = value;
    });
  }
}
