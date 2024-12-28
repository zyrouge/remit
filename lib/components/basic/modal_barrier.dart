import 'package:flutter/widgets.dart';
import '../theme/theme.dart';

class RuiModalBarrier extends StatelessWidget {
  const RuiModalBarrier({
    required this.onDismiss,
    this.dismissible = true,
    super.key,
  });

  final bool dismissible;
  final VoidCallback onDismiss;

  @override
  Widget build(final BuildContext context) => ModalBarrier(
        dismissible: dismissible,
        onDismiss: onDismiss,
        color: RuiTheme.colorSchemeOf(context)
            .backgroundVariant
            .withValues(alpha: 0.5),
      );
}
