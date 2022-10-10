import 'event.dart';

/// Signature for the function that returns a value of type `T`
/// based on a given set of events.
typedef DrivenPropertyResolver<T> = T Function(Set<WidgetEvent> events);

/// Interface for classes that [resolve] to a value of type `T`
/// based on a widget's interactive "event",
/// which is defined as a set of [WidgetEvent]s.
abstract class DrivenProperty<T> {
  /// Returns a value of type `T` that depends on [events].
  ///
  /// Widgets like [TextButton] and [ElevatedButton] apply this method to their
  /// current [WidgetEvent]s to compute colors and other visual parameters
  /// at build time.
  T resolve(Set<WidgetEvent> events);

  /// Resolves the value for the given set of events if `value` is a
  /// [DrivenProperty], otherwise returns the value itself.
  ///
  /// This is useful for widgets that have parameters
  /// which can optionally be a [DrivenProperty].
  static T evaluate<T>(T value, Set<WidgetEvent> events) {
    if (value is DrivenProperty<T>) {
      final DrivenProperty<T> property = value;
      return property.resolve(events);
    }
    return value;
  }

  /// Convenience method for creating a [DrivenProperty]
  /// from a [DrivenPropertyResolver] function alone.
  static DrivenProperty<T> by<T>(DrivenPropertyResolver<T> callback) {
    return _DrivenProperty<T>(callback);
  }

  /// Convenience method for creating a [DrivenProperty]
  /// that resolves to a single value for all events.
  static DrivenProperty<T> all<T>(T value) {
    return _DrivenProperty<T>((events) => value);
  }
}

class _DrivenProperty<T> implements DrivenProperty<T> {
  _DrivenProperty(this._resolver);

  final DrivenPropertyResolver<T> _resolver;

  @override
  T resolve(Set<WidgetEvent> events) => _resolver(events);
}
