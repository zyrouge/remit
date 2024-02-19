import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import '../animations/fade_scale_transition2.dart';
import '../theme/animation_durations.dart';
import '../theme/theme.dart';
import 'button.dart';
import 'icon.dart';
import 'spacer.dart';

class RuiDropdown<T> extends StatefulWidget {
  const RuiDropdown({
    required this.value,
    required this.labels,
    required this.style,
    required this.popupStyle,
    required this.itemStyle,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  final T value;
  final Map<T, String> labels;
  final bool enabled;
  final RuiButtonStyle style;
  final RuiDropdownPopupStyle popupStyle;
  final RuiButtonStyle itemStyle;
  final void Function(T) onChanged;

  @override
  State<RuiDropdown<T>> createState() => _RuiDropdownState<T>();
}

class _RuiDropdownState<T> extends State<RuiDropdown<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final OverlayPortalController overlayController;
  late final LayerLink layerLink;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: RuiAnimationDurations.fast,
    );
    overlayController = OverlayPortalController();
    layerLink = LayerLink();
  }

  @override
  Widget build(final BuildContext context) => CompositedTransformTarget(
        link: layerLink,
        child: LayoutBuilder(
          builder: (
            final BuildContext context,
            final BoxConstraints constraints,
          ) =>
              OverlayPortal(
            controller: overlayController,
            overlayChildBuilder: (final BuildContext context) => Stack(
              children: <Widget>[
                Positioned.fill(
                  child: ModalBarrier(onDismiss: togglePopup),
                ),
                CompositedTransformFollower(
                  link: layerLink,
                  targetAnchor: Alignment.bottomLeft,
                  offset: const Offset(0, 4),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: FadeScaleTransition2(
                      alignment: Alignment.topCenter,
                      animation: animationController,
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: constraints.maxWidth),
                        child: RuiDropdownPopup<T>(
                          value: widget.value,
                          labels: widget.labels,
                          style: widget.popupStyle,
                          itemStyle: widget.itemStyle,
                          onChanged: (final T value) {
                            widget.onChanged(value);
                            togglePopup();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            child: RuiButton(
              active: isOpen,
              style: widget.style,
              onClick: togglePopup,
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(widget.labels[widget.value]!)),
                  RuiSpacer.verticalNormal,
                  RuiIcon(
                    Ionicons.chevron_down_outline,
                    color: DefaultTextStyle.of(context)
                        .style
                        .color!
                        .withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> togglePopup() async {
    setState(() {
      isOpen = !overlayController.isShowing;
    });
    if (isOpen) {
      overlayController.show();
      await animationController.forward();
    } else {
      await animationController.reverse();
      overlayController.hide();
    }
  }
}

class RuiDropdownPopupStyle {
  RuiDropdownPopupStyle({
    required this.color,
    required this.padding,
    required this.borderRadius,
    this.strokeColor,
    this.height,
    this.width,
  });

  factory RuiDropdownPopupStyle.standard(
    final BuildContext context, {
    final EdgeInsets? padding,
    final BorderRadius? borderRadius,
    final double? height,
    final double? width,
  }) {
    final RuiTheme theme = RuiTheme.of(context);
    return RuiDropdownPopupStyle(
      color: theme.colorScheme.background,
      strokeColor: theme.colorScheme.backgroundVariant,
      padding: padding ?? defaultPadding,
      borderRadius: borderRadius ?? defaultBorderRadius,
      height: height,
      width: width,
    );
  }

  final Color color;
  final Color? strokeColor;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final double? height;
  final double? width;

  static final BorderRadius defaultBorderRadius = BorderRadius.circular(8);
  static const EdgeInsets defaultPadding = EdgeInsets.all(2);
}

class RuiDropdownPopup<T> extends StatelessWidget {
  const RuiDropdownPopup({
    required this.value,
    required this.labels,
    required this.style,
    required this.itemStyle,
    required this.onChanged,
    super.key,
  });

  final T value;
  final Map<T, String> labels;
  final RuiDropdownPopupStyle style;
  final RuiButtonStyle itemStyle;
  final void Function(T) onChanged;

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
          children: labels.entries
              .map(
                (final MapEntry<T, String> x) => RuiButton(
                  active: value == x.key,
                  style: itemStyle,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(x.value),
                  ),
                  onClick: () => onChanged(x.key),
                ),
              )
              .toList(),
        ),
      );
}
