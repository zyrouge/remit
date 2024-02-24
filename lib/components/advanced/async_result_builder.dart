import 'package:flutter/widgets.dart';
import '../../utils/async_result.dart';

class RuiAsyncResultBuilder<T, E extends Object> extends StatelessWidget {
  const RuiAsyncResultBuilder({
    required this.result,
    required this.waiting,
    required this.processing,
    required this.success,
    required this.failed,
    super.key,
  });

  final RuiAsyncResult<T, E> result;
  final Widget Function(BuildContext) waiting;
  final Widget Function(BuildContext) processing;
  final Widget Function(BuildContext, T) success;
  final Widget Function(BuildContext, E) failed;

  @override
  Widget build(final BuildContext context) {
    if (result.isWaiting) {
      return waiting(context);
    }
    if (result.isProcessing) {
      return processing(context);
    }
    if (result.isSuccess) {
      return success(context, result.asSuccess.value);
    }
    return failed(context, result.asFailed.error);
  }
}
