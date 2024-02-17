import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import '../localized.dart';
import '../theme/colors.dart';
import 'button.dart';
import 'icon.dart';
import 'interactive.dart';
import 'vertical_content.dart';

class RuiBackButton extends StatelessWidget {
  const RuiBackButton({
    required this.onClick,
    super.key,
  });

  final VoidCallback onClick;

  @override
  Widget build(final BuildContext context) => UnconstrainedBox(
        child: RuiButton(
          style: RuiButtonStyle(
            color: (final _, final __) => RuiColors.transparent,
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.zero,
            textStyle:
                (final BuildContext context, final RuiInteractiveState state) {
              final TextStyle textStyle = DefaultTextStyle.of(context).style;
              if (state == RuiInteractiveState.normal) {
                return textStyle;
              }
              return textStyle.copyWith(color: RuiColors.red500);
            },
          ),
          onClick: onClick,
          child: RuiVerticalContent(
            leading: const RuiIcon(Ionicons.arrow_back_outline),
            child: Text(context.t.back),
          ),
        ),
      );
}
