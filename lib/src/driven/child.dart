import 'package:flutter/widgets.dart';

import '../event.dart';
import '../property.dart';

/// A widget that displays different child widgets based on events.
///
/// The `DrivenChild` class allows you to define different child widgets for
/// various event states (e.g., enabled, error, disabled, loading, etc.) and
/// conditionally display the appropriate widget based on the current events.
///
/// You can create a `DrivenChild` instance in several ways:
///  * Specifying the `enabled` widget and optional widgets for other events.
///  * Providing a single widget for all states using `DrivenChild.all`.
///  * Using a map of custom event-widget associations.
///    to determine the child widget based on events with `DrivenChild.map`.
///  * Creating a resolver object with a callback using `DrivenChild.by`.
class DrivenChild<T extends Widget?> extends StatelessWidget
    implements DrivenProperty<T> {
  /// Creates a `DrivenChild` with the provided `enabled` widget and optional
  /// widgets for various event states.
  ///
  /// The `enabled` widget is displayed when none of the other event states
  /// match. You can also provide specific widgets for events like error,
  /// disabled, loading, etc.
  const DrivenChild(
    this.atEnabled, {
    this.atError,
    this.atDisabled,
    this.atLoading,
    this.atDragged,
    this.atPressed,
    this.atHovered,
    this.atFocused,
    this.atIndeterminate,
    this.atSelected,
    this.registry = const {},
    super.key,
  });

  /// Creates a `DrivenChild` with the provided `enabled` widget for all states.
  ///
  /// This constructor simplifies creating a `DrivenChild` where the same widget
  /// is displayed for all event states.
  const DrivenChild.all(this.atEnabled, {super.key})
      : atError = null,
        atDisabled = null,
        atLoading = null,
        atDragged = null,
        atPressed = null,
        atHovered = null,
        atFocused = null,
        atIndeterminate = null,
        atSelected = null,
        registry = const {};

  /// Creates a `DrivenChild` with the provided `enabled` widget
  /// and a map of custom event-widget associations to determine
  /// the child widget based on events.
  ///
  /// This constructor allows for more flexibility in determining the child
  /// widget based on events. You provide a function that takes the current
  /// events as input and returns the appropriate widget.
  const DrivenChild.map(this.atEnabled, this.registry, {super.key})
      : atError = null,
        atDisabled = null,
        atLoading = null,
        atDragged = null,
        atPressed = null,
        atHovered = null,
        atFocused = null,
        atIndeterminate = null,
        atSelected = null;

  /// Creates a `DrivenChild` with a callback function
  /// that determines the child widget.
  ///
  /// This factory method allows you to create a `DrivenChild` instance by
  /// providing a callback function that takes the current events as input and
  /// returns the appropriate widget.
  factory DrivenChild.by(DrivenPropertyResolver<T> callback) {
    return DrivenChildResolver<T>(callback);
  }

  /// The widget to display when the widget is enabled.
  final T atEnabled;

  /// The widget to display when the `WidgetEvent.error` event occurs.
  final T? atError;

  /// The widget to display when the `WidgetEvent.disabled` event occurs.
  final T? atDisabled;

  /// The widget to display when the `WidgetEvent.loading` event occurs.
  final T? atLoading;

  /// The widget to display when the `WidgetEvent.dragged` event occurs.
  final T? atDragged;

  /// The widget to display when the `WidgetEvent.pressed` event occurs.
  final T? atPressed;

  /// The widget to display when the `WidgetEvent.hovered` event occurs.
  final T? atHovered;

  /// The widget to display when the `WidgetEvent.focused` event occurs.
  final T? atFocused;

  /// The widget to display when the `WidgetEvent.indeterminate` event occurs.
  final T? atIndeterminate;

  /// The widget to display when the `WidgetEvent.selected` event occurs.
  final T? atSelected;

  /// A map of custom event-widget associations.
  final Map<WidgetEvent, T?> registry;

  /// Combines the default and custom event-to-widget mappings.
  ///
  /// This getter returns a combined map containing both the default event-to-widget
  /// mappings (`error`, `disabled`, etc.) and any additional mappings defined in the `custom` map.
  Map<WidgetEvent, T?> get driven => {
        WidgetEvent.error: atError,
        WidgetEvent.disabled: atDisabled,
        WidgetEvent.loading: atLoading,
        WidgetEvent.dragged: atDragged,
        WidgetEvent.pressed: atPressed,
        WidgetEvent.hovered: atHovered,
        WidgetEvent.focused: atFocused,
        WidgetEvent.indeterminate: atIndeterminate,
        WidgetEvent.selected: atSelected,
      }..addAll(registry);

  @override
  T resolve(events) {
    T result = atEnabled;
    if (driven.isNotEmpty) {
      for (final e in driven.entries) {
        if (events.contains(e.key)) {
          result = _resolveSingle(e.value, result);
          break;
        }
      }
    }
    return result;
  }

  /// Resolves a single event mapping entry.
  ///
  /// This helper function checks if the provided child widget is not null
  /// and returns it. Otherwise, it returns the fallback widget.
  T _resolveSingle(T? child, T fallback) {
    if (child != null) return child;
    return fallback;
  }

  /// Evaluates a given value based on the provided events.
  ///
  /// This static method is a convenience wrapper around `DrivenProperty.evaluate`.
  static T evaluate<T extends Widget?>(T value, Set<WidgetEvent> events) {
    return DrivenProperty.evaluate<T>(value, events);
  }

  @override
  Widget build(BuildContext context) {
    return resolve({}) ?? const SizedBox();
  }
}

class DrivenChildResolver<T extends Widget?> extends DrivenChild<T> {
  /// Creates a `DrivenChildResolver` from a provided resolver function.
  ///
  /// This class allows you to dynamically determine the child widget based on
  /// events using a custom resolver function.
  DrivenChildResolver(this.resolver, {super.key}) : super(resolver({}));

  /// The resolver function that determines the child widget based on events.
  final DrivenPropertyResolver<T> resolver;

  @override
  T resolve(events) => resolver(events);

  /// Evaluates a given value based on the provided events.
  ///
  /// This static method is a convenience wrapper around `DrivenProperty.evaluate`.
  static T evaluate<T extends Widget?>(T value, Set<WidgetEvent> events) {
    return DrivenProperty.evaluate<T>(value, events);
  }
}
