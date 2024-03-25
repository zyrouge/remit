import 'random.dart';

extension RuiListUtils<T> on List<T> {
  Map<K, V> associate<K, V>(final MapEntry<K, V> Function(T) transform) =>
      Map<K, V>.fromEntries(map(transform));

  Map<K, T> associateBy<K>(final K Function(T) keySelector) =>
      <K, T>{for (final T x in this) keySelector(x): x};

  Map<T, V> associateWith<V>(final V Function(T) valueTransform) =>
      <T, V>{for (final T x in this) x: valueTransform(x)};

  Map<K, V> associateByWith<K, V>(
    final K Function(T) keySelector,
    final V Function(T) valueTransform,
  ) =>
      <K, V>{for (final T x in this) keySelector(x): valueTransform(x)};

  T random() => this[ruiRandom.nextInt(length)];

  T? firstWhereOrNull(final bool Function(T) matcher) {
    for (final T x in this) {
      if (matcher(x)) return x;
    }
    return null;
  }
}
