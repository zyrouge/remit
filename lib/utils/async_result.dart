sealed class RuiAsyncResult<T, E extends Object> {
  const RuiAsyncResult();

  bool isState<S extends RuiAsyncResult<T, E>>() => this is S;

  S asState<S extends RuiAsyncResult<T, E>>() {
    final RuiAsyncResult<T, E> value = this;
    if (value is! S) {
      throw Exception('Cannot cast "$runtimeType" as "${S.runtimeType}"');
    }
    return value;
  }

  S? asStateOrNull<S extends RuiAsyncResult<T, E>>() {
    final RuiAsyncResult<T, E> value = this;
    if (value is! S) return null;
    return value;
  }

  bool get isWaiting => isState<RuiAsyncWaiting<T, E>>();
  bool get isProcessing => isState<RuiAsyncProcessing<T, E>>();
  bool get isSuccess => isState<RuiAsyncSuccess<T, E>>();
  bool get isFailed => isState<RuiAsyncFailed<T, E>>();

  RuiAsyncWaiting<T, E> get asWaiting => asState();
  RuiAsyncProcessing<T, E> get asProcessing => asState();
  RuiAsyncSuccess<T, E> get asSuccess => asState();
  RuiAsyncFailed<T, E> get asFailed => asState();

  RuiAsyncWaiting<T, E>? get asWaitingOrNull => asStateOrNull();
  RuiAsyncProcessing<T, E>? get asProcessingOrNull => asStateOrNull();
  RuiAsyncSuccess<T, E>? get asSuccessOrNull => asStateOrNull();
  RuiAsyncFailed<T, E>? get asFailedOrNull => asStateOrNull();

  static RuiAsyncWaiting<T, E> waiting<T, E extends Object>() =>
      RuiAsyncWaiting<T, E>();

  static RuiAsyncProcessing<T, E> processing<T, E extends Object>() =>
      RuiAsyncProcessing<T, E>();

  static RuiAsyncSuccess<T, E> success<T, E extends Object>(final T value) =>
      RuiAsyncSuccess<T, E>(value);

  static RuiAsyncFailed<T, E> failed<T, E extends Object>(final E error) =>
      RuiAsyncFailed<T, E>(error);
}

class RuiAsyncWaiting<T, E extends Object> extends RuiAsyncResult<T, E> {
  const RuiAsyncWaiting();
}

class RuiAsyncProcessing<T, E extends Object> extends RuiAsyncResult<T, E> {
  const RuiAsyncProcessing();
}

class RuiAsyncSuccess<T, E extends Object> extends RuiAsyncResult<T, E> {
  const RuiAsyncSuccess(this.value);

  final T value;
}

class RuiAsyncFailed<T, E extends Object> extends RuiAsyncResult<T, E> {
  const RuiAsyncFailed(this.error);

  final E error;
}
