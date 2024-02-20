sealed class RuiAsyncResult<T, E extends Object> {
  const RuiAsyncResult();

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
