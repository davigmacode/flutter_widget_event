import 'package:flutter/foundation.dart';
import 'event.dart';

/// Signature for the function that returns a value of type `T`
/// based on a given set of events.
typedef DrivenPropertyResolver<T> = T Function(Set<WidgetEvent> events);

/// Interface for classes that [resolve] to a value of type `T`
/// based on a widget's interactive "event",
/// which is defined as a set of [WidgetEvent]s.
class DrivenProperty<T> {
  DrivenProperty(this.resolver);

  @protected
  final DrivenPropertyResolver<T> resolver;

  /// Resolves the value for the given set of events if `value` is a
  /// [DrivenProperty], otherwise returns the value itself.
  ///
  /// This is useful for widgets that have parameters
  /// which can optionally be a [DrivenProperty].
  static T resolve<T>(T value, Set<WidgetEvent> events) {
    if (value is DrivenProperty<T>) {
      final DrivenProperty<T> property = value;
      return property.resolver(events);
    }
    return value;
  }

  /// Convenience method for creating a [DrivenProperty]
  /// that resolves to a single value for all events.
  static DrivenProperty<T> all<T>(T value) {
    return DrivenProperty<T>((events) => value);
  }
}
