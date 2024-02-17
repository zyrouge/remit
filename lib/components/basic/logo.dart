import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../services/assets.dart';
import '../theme/colors.dart';

class RuiLogo extends StatelessWidget {
  const RuiLogo({
    required this.size,
    this.color,
    super.key,
  });

  final double size;
  final Color? color;

  @override
  Widget build(final BuildContext context) => SvgPicture.asset(
        RuiImageAssets.logoTransparent,
        width: size,
        height: size,
        theme: SvgTheme(
          currentColor: color ??
              DefaultTextStyle.of(context).style.color ??
              RuiColors.black,
        ),
      );
}
