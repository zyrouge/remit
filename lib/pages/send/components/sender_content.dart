import 'package:flutter/widgets.dart';
import 'package:remit/exports.dart';
import '../../../components/advanced/async_result_builder.dart';
import '../../../components/advanced/explorer/explorer.dart';
import '../../../components/basic/divider.dart';
import '../../../components/basic/spacer.dart';
import '../../../components/theme/theme.dart';
import '../../../utils/async_result.dart';

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
  List<String> paths = <String>[RemitSender.filesystemRootBasename];
  RuiAsyncResult<RemitFilesystemStaticDataPairs, Object> entities =
      RuiAsyncResult.waiting();

  Future<void> updatePath(final List<String> nPaths) async {
    setState(() {
      paths = nPaths;
    });
    try {
      entities = RuiAsyncResult.processing();
      final RemitFilesystemEntity? folder =
          await widget.sender.filesystem.resolvePaths(nPaths);
      if (folder is! RemitFolder) return;
      final RemitFilesystemStaticDataPairs pairs =
          await folder.listAsStaticDataPairs();
      setState(() {
        entities = RuiAsyncResult.success(pairs);
      });
    } catch (error) {
      entities = RuiAsyncResult.failed(error);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final RuiTheme theme = RuiTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Sharing as ${sender.info.username} to ${sender.connections.length} connections.',
        ),
        RuiSpacer.verticalNormal,
        const RuiDivider.horizontal(),
        RuiSpacer.verticalTight,
        RuiAsyncResultBuilder<RemitFilesystemStaticDataPairs, Object>(
          result: entities,
          waiting: (final BuildContext context) => const SizedBox.shrink(),
          processing: (final BuildContext context) => const SizedBox.shrink(),
          success: (
            final BuildContext context,
            final RemitFilesystemStaticDataPairs value,
          ) =>
              RuiExplorer(files: value.files, folders: value.folders),
          failed: (final BuildContext context, final _) =>
              const SizedBox.shrink(),
        ),
      ],
    );
  }

  RemitSender get sender => widget.sender;
}
