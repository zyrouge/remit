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
import '../../../components/theme/theme.dart';
import '../../../utils/async_result.dart';
import '../../../utils/extensions.dart';
import 'queue_dialog.dart';

class RuiReceivePageContent extends StatefulWidget {
  const RuiReceivePageContent({
    required this.receiver,
    required this.queue,
    required this.toggleQueueDialog,
    super.key,
  });

  final RemitReceiver receiver;
  final RuiReceiverDownloadQueue queue;
  final VoidCallback toggleQueueDialog;

  @override
  State<RuiReceivePageContent> createState() => _RuiReceivePageContentState();
}

class _RuiReceivePageContentState extends State<RuiReceivePageContent> {
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
          await receiver.connection.filesystemList(paths.join('/'));
      if (!mounted) {
        return;
      }
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

  Future<void> downloadSelected() => widget.queue.addToQueue(
        parts: paths,
        folders: selectedFolders.toList(),
        files: selectedFiles.toList(),
      );

  Future<void> downloadAll() async {
    final RemitFilesystemStaticDataPairs? pairs =
        entities.asSuccessOrNull?.value;
    if (pairs == null) {
      return;
    }
    await widget.queue.addToQueue(
      parts: paths,
      folders: pairs.folders.toList(),
      files: pairs.files.toList(),
    );
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
        Wrap(
          spacing: 40,
          runSpacing: RuiSpacer.normalPx,
          children: <Widget>[
            buildLabeledText(
              context,
              context.t.sharingAs,
              receiver.info.username,
            ),
            buildLabeledText(
              context,
              context.t.entities,
              (entities.asSuccessOrNull?.value.length ?? 0).toString(),
            ),
          ],
        ),
        RuiSpacer.verticalNormal,
        const RuiDivider.horizontal(),
        RuiSpacer.verticalNormal,
        Row(
          children: <Widget>[
            takeValue(
              selectedFiles.isNotEmpty || selectedFolders.isNotEmpty,
              (final bool hasSelectedEntities) => RuiButton(
                enabled: hasSelectedEntities,
                style: RuiButtonStyle.primary(),
                onClick: downloadSelected,
                child: RuiHorizontalContent(
                  leading: const RuiIcon(Ionicons.download_outline),
                  child: Text(context.t.downloadSelected),
                ),
              ),
            ),
            RuiSpacer.horizontalCompact,
            RuiButton(
              enabled: entities.asSuccessOrNull?.value.isNotEmpty ?? false,
              style: RuiButtonStyle.outlined(),
              onClick: downloadAll,
              child: RuiHorizontalContent(
                leading: const RuiIcon(Ionicons.file_tray_stacked_outline),
                child: Text(context.t.downloadAll),
              ),
            ),
            const Expanded(child: SizedBox.shrink()),
            RuiButton(
              style: RuiButtonStyle.surface(),
              onClick: widget.toggleQueueDialog,
              child: RuiHorizontalContent(
                leading: const RuiIcon(Ionicons.list),
                child: Text(context.t.queue),
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
                text: TextSpan(text: context.t.noFilesAreBeingShared),
                style: RuiSimpleMessageStyle.dimmed(
                  context,
                  padding: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height / 6,
                  ),
                ),
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

  RemitReceiver get receiver => widget.receiver;
}
