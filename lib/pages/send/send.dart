// import 'dart:io';
// import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';
// import 'package:remit/exports.dart';
// import '../../components/theme/responsivity.dart';
// import '../../services/settings/settings.dart';
// import '../../utils/device.dart';
// import '../../utils/log.dart';
// import '../../utils/random_names.dart';

// enum _RuiSenderConnectionStatus {
//   uninitialized,
//   parsingDevice,
//   fetchingNetworks,
//   creating,
// }

// class RuiSendPage extends StatefulWidget {
//   const RuiSendPage({
//     super.key,
//   });

//   @override
//   State<RuiSendPage> createState() => _RuiSendPageState();
// }

// class _RuiSendPageState extends State<RuiSendPage> {
//   late RemitSender sender;

//   @override
//   void initState() {
//     super.initState();
//     initSender();
//   }

//   Future<void> initSender() async {
//     final RuiSettingsData settings = context.read();
//     final String? device = await getDeviceName();
//     final List<InternetAddress> addresses =
//         await RemitServer.getAvailableNetworks();
//     sender = await RemitSender.create(
//       info: RemitSenderBasicInfo(
//         username: settings.username ?? RuiRandomNames.generate(),
//         device: device,
//       ),
//       address: RemitConnectionAddress(addresses.first.address, 0),
//       secure: false,
//       logger: log,
//       onConnectionRequest: ({
//         required final RemitConnectionAddress receiverAddress,
//         required final RemitReceiverBasicInfo receiverInfo,
//       }) async {
//         // TODO
//         return false;
//       },
//     );
//   }

//   @override
//   Widget build(final BuildContext context) {
//     return RuiScaffold(
//       maxWidth: RuiResponsivity.md,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[],
//       ),
//     );
//   }
// }
