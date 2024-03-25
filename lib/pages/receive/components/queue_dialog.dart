import 'package:flutter/widgets.dart';
import 'package:remit/exports.dart';
import '../../../components/basic/dialog_box.dart';
import '../../../components/basic/simple_message.dart';
import '../../../components/basic/spacer.dart';
import '../../../components/localized.dart';
import '../../../components/theme/theme.dart';
import '../../../services/filesystem/file_saver.dart';
import '../../../utils/list.dart';
import '../../../utils/others.dart';

class RuiReceivePageQueue extends StatefulWidget {
  const RuiReceivePageQueue({
    required this.queue,
    super.key,
  });

  final RuiReceiverDownloadQueue queue;

  @override
  State<RuiReceivePageQueue> createState() => _RuiReceivePageQueueState();
}

class _RuiReceivePageQueueState extends State<RuiReceivePageQueue> {
  @override
  void initState() {
    super.initState();
    queue.onUpdate.subscribe(onQueueUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    queue.onUpdate.unsubscribe(onQueueUpdate);
  }

  @override
  Widget build(final BuildContext context) {
    final RuiTheme theme = RuiTheme.of(context);
    return RuiDialogBox(
      style: RuiDialogBoxStyle.standard(context),
      title: Text(context.t.queue),
      body: queue.entities.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (final RuiReceiverDownloadItem x in queue.entities)
                  Row(
                    children: <Widget>[
                      Text(x.path),
                      RuiSpacer.horizontalNormal,
                      const Expanded(child: SizedBox.shrink()),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '${bytesToString(context.t, x.progress)}/${bytesToString(context.t, x.size)}',
                          ),
                          Text('${x.progressPercent}%'),
                        ],
                      ),
                    ],
                  ),
              ],
            )
          : RuiSimpleMessage.text(
              style: RuiSimpleMessageStyle.dimmed(
                context,
                padding: const EdgeInsets.only(top: 8),
              ),
              text: context.t.noFilesAreBeingDownloaded,
            ),
    );
  }

  void onQueueUpdate(final _) {
    setState(() {});
  }

  RuiReceiverDownloadQueue get queue => widget.queue;
}

enum RuiReceiverDownloadItemState {
  waiting,
  downloading,
  finished,
  failed,
}

class RuiReceiverDownloadItem {
  RuiReceiverDownloadItem(
    this.path, {
    required this.size,
    this.state = RuiReceiverDownloadItemState.waiting,
    this.progress = 0,
  });

  final String path;
  final int size;
  RuiReceiverDownloadItemState state;
  int progress;

  double get progressRatio => progress / size;
  int get progressPercent => (progressRatio * 100).toInt();
}

class RuiReceiverDownloadQueue {
  RuiReceiverDownloadQueue(this.receiver);

  final RemitReceiver receiver;
  final List<RuiReceiverDownloadItem> entities = <RuiReceiverDownloadItem>[];
  final RemitEventer<void> onUpdate = RemitEventer<void>();

  bool _running = false;

  Future<void> _downloadFile(final RuiReceiverDownloadItem x) async {
    final Stream<List<int>> stream =
        await receiver.connection.filesystemRead(x.path);
    await RuiFileSaver.saveFile(x.path, stream, (final int progress) {
      x.progress = progress;
      onUpdate.dispatch(null);
    });
  }

  Future<void> _start() async {
    if (_running) return;
    _running = true;
    while (true) {
      final RuiReceiverDownloadItem? x = entities.firstWhereOrNull(
        (final RuiReceiverDownloadItem x) =>
            x.state == RuiReceiverDownloadItemState.waiting,
      );
      if (x == null) break;
      await _downloadFile(x);
    }
    _running = false;
  }

  // Future<void> _downloadFolder(
  //   final List<String> parts,
  //   final RemitFolderStaticData folder,
  // ) async {
  //   final RemitFilesystemStaticDataPairs pairs =
  //       await receiver.connection.filesystemList(folder.basename);
  //   final List<String> nParts = parts.toList()..add(folder.basename);
  //   for (final RemitFolderStaticData x in pairs.folders) {
  //     await downloadFolder(nParts, x);
  //   }
  //   for (final RemitFileStaticData x in pairs.files) {
  //     await downloadFile(nParts, x);
  //   }
  // }

  Future<void> addToQueue({
    required final List<String> parts,
    required final List<RemitFolderStaticData> folders,
    required final List<RemitFileStaticData> files,
  }) async {
    // TODO: fix paths
    for (final RemitFileStaticData x in files) {
      entities.add(RuiReceiverDownloadItem(x.basename, size: x.size));
    }
    // for (final RemitFolderStaticData x in folders) {
    //   await _downloadFolder(parts, x);
    // }
    // for (final RemitFileStaticData x in files) {
    //   await _downloadFile(parts, x);
    // }
    _start();
  }
}
