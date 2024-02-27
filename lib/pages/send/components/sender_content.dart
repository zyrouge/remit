import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:remit/exports.dart';
import '../../../components/advanced/async_result_builder.dart';
import '../../../components/advanced/explorer/explorer.dart';
import '../../../components/basic/button.dart';
import '../../../components/basic/divider.dart';
import '../../../components/basic/horizontal_content.dart';
import '../../../components/basic/icon.dart';
import '../../../components/basic/simple_message.dart';
import '../../../components/basic/spacer.dart';
import '../../../components/localized.dart';
import '../../../components/theme/animation_durations.dart';
import '../../../components/theme/theme.dart';
import '../../../services/filesystem/file_picker.dart';
import '../../../utils/async_result.dart';
import '../../../utils/extensions.dart';

class RuiSendPageSenderContent extends StatefulWidget {
  const RuiSendPageSenderContent({
    required this.sender,
    super.key,
  });

  final RemitSender sender;

  @override
  State<RuiSendPageSenderContent> createState() =>
      _RuiSendPageSenderContentState();
}

class _RuiSendPageSenderContentState extends State<RuiSendPageSenderContent> {
  List<String> paths = <String>[];
  RuiAsyncResult<RemitFilesystemStaticDataPairs, Object> entities =
      RuiAsyncResult.waiting();
  final Set<RemitFileStaticData> selectedFiles = <RemitFileStaticData>{};
  final Set<RemitFolderStaticData> selectedFolders = <RemitFolderStaticData>{};

  @override
  void initState() {
    super.initState();
    updatePath(<String>[]);
  }

  Future<void> updatePath(final List<String> parts) async {
    setState(() {
      paths = parts;
      selectedFiles.clear();
      selectedFolders.clear();
    });
    try {
      entities = RuiAsyncResult.processing();
      final RemitFilesystemStaticDataPairs pairs =
          await widget.sender.filesystem.listAsStaticDataPairs();
      if (!mounted) return;
      setState(() {
        entities = RuiAsyncResult.success(pairs);
      });
    } catch (error) {
      entities = RuiAsyncResult.failed(error);
    }
  }

  Future<void> pushPath(final String part) =>
      updatePath(paths + <String>[part]);

  Future<void> popPath() => updatePath(paths.sublist(0, paths.length - 1));

  Future<void> openFilePicker() async {
    final List<RuiPickedFile> files = await RuiFilePicker.pick();
    for (final RuiPickedFile x in files) {
      widget.sender.updateFilesystem((final RemitVirtualFolder root) {
        root.addEntity(x);
      });
    }
    await updatePath(paths);
  }

  Future<void> removeSelectedFiles() async {
    for (final RemitFileStaticData x in selectedFiles) {
      widget.sender.updateFilesystem((final RemitVirtualFolder root) {
        // TODO: use remove method
        root.entities.remove(x.basename);
      });
    }
    for (final RemitFolderStaticData x in selectedFolders) {
      widget.sender.updateFilesystem((final RemitVirtualFolder root) {
        // TODO: use remove method
        root.entities.remove(x.basename);
      });
    }
    await updatePath(paths);
  }

  void toggleFileSelect(final RemitFileStaticData file) {
    if (selectedFiles.contains(file)) {
      selectedFiles.remove(file);
    } else {
      selectedFiles.add(file);
    }
    setState(() {});
  }

  void toggleFolderSelect(final RemitFolderStaticData folder) {
    if (selectedFolders.contains(folder)) {
      selectedFolders.remove(folder);
    } else {
      selectedFolders.add(folder);
    }
    setState(() {});
  }

  Widget buildLabeledText(
    final BuildContext context,
    final String label,
    final String text,
  ) {
    final RuiTheme theme = RuiTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: theme.textTheme.small),
        RuiSpacer.verticalTight,
        Text(text, style: theme.textTheme.title),
      ],
    );
  }

  @override
  Widget build(final BuildContext context) {
    final RuiTheme theme = RuiTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildLabeledText(
              context,
              context.t.sharingAs,
              widget.sender.info.username,
            ),
            const RuiSpacer.horizontal(40),
            buildLabeledText(
              context,
              context.t.connections,
              widget.sender.connections.length.toString(),
            ),
            const RuiSpacer.horizontal(40),
            buildLabeledText(
              context,
              context.t.entities,
              widget.sender.filesystem.entities.length.toString(),
            ),
          ],
        ),
        RuiSpacer.verticalNormal,
        const RuiDivider.horizontal(),
        RuiSpacer.verticalNormal,
        Row(
          children: <Widget>[
            RuiButton(
              style: RuiButtonStyle.primary(),
              onClick: openFilePicker,
              child: RuiHorizontalContent(
                leading: const RuiIcon(Ionicons.add_outline),
                child: Text(context.t.addFile),
              ),
            ),
            RuiSpacer.horizontalCompact,
            takeValue(
              selectedFiles.isNotEmpty || selectedFolders.isNotEmpty,
              (final bool hasSelectedEntities) => RuiButton(
                enabled: hasSelectedEntities,
                style: RuiButtonStyle.outlined(),
                onClick: removeSelectedFiles,
                child: RuiHorizontalContent(
                  leading: AnimatedSwitcher(
                    duration: RuiAnimationDurations.fastest,
                    child: RuiIcon(
                      Ionicons.trash_outline,
                      key: ValueKey<bool>(hasSelectedEntities),
                      color:
                          hasSelectedEntities ? theme.colorScheme.error : null,
                    ),
                  ),
                  child: Text(context.t.removeSelected),
                ),
              ),
            ),
          ],
        ),
        RuiSpacer.verticalNormal,
        RuiAsyncResultBuilder<RemitFilesystemStaticDataPairs, Object>(
          result: entities,
          waiting: (final BuildContext context) => const SizedBox.shrink(),
          processing: (final BuildContext context) => RuiSimpleMessage.icon(
            icon: Ionicons.documents_outline,
            text: TextSpan(text: context.t.loading),
            style: RuiSimpleMessageStyle.standard(context),
          ),
          success: (
            final BuildContext context,
            final RemitFilesystemStaticDataPairs value,
          ) {
            if (value.files.isEmpty && value.folders.isEmpty) {
              return RuiSimpleMessage.icon(
                icon: Ionicons.documents_outline,
                text: TextSpan(text: context.t.thisIsEmptyMaybeAddSomeFiles),
                style: RuiSimpleMessageStyle.dimmed(context),
              );
            }
            return RuiExplorer(
              files: value.files
                  .map(
                    (final RemitFileStaticData x) =>
                        RuiExplorerItem<RemitFileStaticData>(
                      value: x,
                      selected: selectedFiles.contains(x),
                      onSelect: () => toggleFileSelect(x),
                      onClick: () => toggleFileSelect(x),
                    ),
                  )
                  .toList(),
              folders: value.folders
                  .map(
                    (final RemitFolderStaticData x) =>
                        RuiExplorerItem<RemitFolderStaticData>(
                      value: x,
                      selected: selectedFolders.contains(x),
                      onSelect: () => toggleFolderSelect(x),
                      onClick: () => pushPath(x.basename),
                    ),
                  )
                  .toList(),
            );
          },
          // TODO: handle error
          failed: (final BuildContext context, final _) =>
              const SizedBox.shrink(),
        ),
      ],
    );
  }

  RemitSender get sender => widget.sender;
}
