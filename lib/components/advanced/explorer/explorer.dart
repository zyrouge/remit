import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:remit/exports.dart';
import '../../../utils/others.dart';
import '../../basic/button.dart';
import '../../basic/horizontal_content.dart';
import '../../basic/icon.dart';
import '../../basic/spacer.dart';
import '../../localized.dart';
import '../../theme/animation_durations.dart';
import '../../theme/theme.dart';

class RuiExplorerItem<T> {
  const RuiExplorerItem({
    required this.value,
    required this.selected,
    required this.onSelect,
    required this.onClick,
  });

  final T value;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onClick;
}

class RuiExplorer extends StatelessWidget {
  const RuiExplorer({
    required this.files,
    required this.folders,
    super.key,
  });

  final List<RuiExplorerItem<RemitFileStaticData>> files;
  final List<RuiExplorerItem<RemitFolderStaticData>> folders;

  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            for (final RuiExplorerItem<RemitFileStaticData> x in files)
              _RuiExplorerListItem(
                name: x.value.basename,
                label: bytesToString(context.t, x.value.size),
                icon: Ionicons.document,
                selected: x.selected,
                onSelect: x.onSelect,
                onClick: x.onClick,
              ),
            for (final RuiExplorerItem<RemitFolderStaticData> x in folders)
              _RuiExplorerListItem(
                name: x.value.basename,
                icon: Ionicons.folder,
                selected: x.selected,
                onSelect: x.onSelect,
                onClick: x.onClick,
              ),
          ],
        ),
      );
}

class _RuiExplorerListItem extends StatelessWidget {
  const _RuiExplorerListItem({
    required this.name,
    required this.icon,
    required this.selected,
    required this.onSelect,
    required this.onClick,
    this.label,
  });

  final String name;
  final String? label;
  final IconData icon;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onClick;

  @override
  Widget build(final BuildContext context) {
    final RuiTheme theme = RuiTheme.of(context);
    return RuiButton(
      style: RuiButtonStyle.text(
        padding: RuiButtonStyle.defaultPadding.copyWith(left: 0),
      ),
      onClick: onClick,
      child: RuiHorizontalContent(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RuiButton(
              style: RuiButtonStyle.text(
                borderRadius: BorderRadius.zero,
                padding: EdgeInsets.zero,
              ),
              onClick: onSelect,
              child: AnimatedSwitcher(
                duration: RuiAnimationDurations.fastest,
                child: DecoratedBox(
                  key: ValueKey<bool>(selected),
                  decoration: BoxDecoration(
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.backgroundVariant,
                    border: Border.all(
                      color: selected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surface,
                    ),
                  ),
                  child: SizedBox.square(
                    dimension: 12,
                    child: selected
                        ? RuiIcon(
                            Ionicons.checkmark_outline,
                            size: 8,
                            color: selected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onBackgroundVariant,
                          )
                        : null,
                  ),
                ),
              ),
            ),
            RuiSpacer.horizontalNormal,
            RuiIcon(
              icon,
              color: RuiTheme.colorSchemeOf(context).primaryLightVariant,
            ),
          ],
        ),
        trailing: label != null ? Text(label!) : null,
        child: Expanded(child: Text(name)),
      ),
    );
  }
}
