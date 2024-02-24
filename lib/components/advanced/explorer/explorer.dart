import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:remit/exports.dart';
import '../../basic/button.dart';
import '../../basic/horizontal_content.dart';
import '../../basic/icon.dart';
import '../../basic/spacer.dart';
import '../../theme/theme.dart';

class RuiExplorer extends StatelessWidget {
  const RuiExplorer({
    required this.files,
    required this.folders,
    super.key,
  });

  final List<RemitFileStaticData> files;
  final List<RemitFolderStaticData> folders;

  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            for (final RemitFileStaticData x in files)
              _RuiExplorerListItem(
                basename: x.basename,
                icon: Ionicons.document,
                selected: false,
              ),
            for (final RemitFolderStaticData x in folders)
              _RuiExplorerListItem(
                basename: x.basename,
                icon: Ionicons.folder,
                selected: false,
              ),
          ],
        ),
      );
}

class _RuiExplorerListItem extends StatelessWidget {
  const _RuiExplorerListItem({
    required this.basename,
    required this.icon,
    required this.selected,
  });

  final String basename;
  final IconData icon;
  final bool selected;

  @override
  Widget build(final BuildContext context) => RuiButton(
        style: RuiButtonStyle.text(padding: EdgeInsets.zero),
        onClick: () {},
        child: RuiHorizontalContent(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const RuiIcon(Ionicons.square_outline),
              RuiSpacer.horizontalNormal,
              RuiIcon(
                icon,
                color: RuiTheme.colorSchemeOf(context).primaryLightVariant,
              ),
            ],
          ),
          trailing: RuiButton(
            style: RuiButtonStyle.text(padding: EdgeInsets.zero),
            onClick: () {},
            child: const RuiIcon(Ionicons.ellipsis_horizontal_outline),
          ),
          child: Expanded(child: Text(basename)),
        ),
      );
}
