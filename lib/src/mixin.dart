import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'event.dart';

/// Mixin for [State] classes that require knowledge of changing [WidgetEvent]
/// values for their child widgets.
///
/// This mixin does nothing by mere application to a [State] class, but is
/// helpful when writing `build` methods that include child [InkWell],
/// [GestureDetector], [MouseRegion], or [Focus] widgets. Instead of manually
/// creating handlers for each type of user interaction, such [State] classes can
/// instead provide a `ValueChanged<bool>` function and allow [WidgetEventMixin]
/// to manage the set of active [WidgetEvent]s, and the calling of [setState]
/// as necessary.
///
/// {@tool snippet}
/// This example shows how to write a [StatefulWidget] that uses the
/// [WidgetEventMixin] class to watch [WidgetEvent] values.
///
/// ```dart
/// class MyWidget extends StatefulWidget {
///   const MyWidget({required this.color, required this.child, Key? key}) : super(key: key);
///
///   final Color color;
///   final Widget child;
///
///   @override
///   State<MyWidget> createState() => MyWidgetState();
/// }
///
/// class MyWidgetState extends State<MyWidget> with WidgetEventMixin<MyWidget> {
///   @override
///   Widget build(BuildContext context) {
///     return InkWell(
///       onFocusChange: updateWidgetEvent(WidgetEvent.focused),
///       child: Container(
///         color: DrivenProperty.evaluate<Color>(widget.color, widgetEvents),
///         child: widget.child,
///       ),
///     );
///   }
/// }
/// ```
/// {@end-tool}
@optionalTypeArgs
mixin WidgetEventMixin<T extends StatefulWidget> on State<T> {
  /// Managed set of active [WidgetEvent] values; designed to be passed to
  /// [DrivenProperty.resolve] methods.
  ///
  /// To mutate and have [setState] called automatically for you, use
  /// [setWidgetEvent], [addWidgetEvent], or [removeWidgetEvent]. Directly
  /// mutating the set is possible, and may be necessary if you need to alter its
  /// list without calling [setState] (and thus triggering a re-render).
  ///
  /// To check for a single condition, convenience getters [isPressed], [isHovered],
  /// [isFocused], etc, are available for each [WidgetEvent] value.
  @protected
  Set<WidgetEvent> widgetEvents = <WidgetEvent>{};

  /// Called when [widgetEvents] of this [State] object changes.
  @protected
  void didChangeWidgetEvent() {}

  /// Callback factory which accepts a [WidgetEvent] value and returns a
  /// closure to mutate [widgetEvents] and call [setState].
  ///
  /// Accepts an optional second named parameter, `onChanged`, which allows
  /// arbitrary functionality to be wired through the [WidgetEventMixin].
  /// If supplied, the [onChanged] function is only called when child widgets
  /// report events that make changes to the current set of [WidgetEvent]s.
  ///
  /// {@tool snippet}
  /// This example shows how to use the [updateWidgetEvent] callback factory
  /// in other widgets, including the optional [onChanged] callback.
  ///
  /// ```dart
  /// class MyWidget extends StatefulWidget {
  ///   const MyWidget({this.onPressed, Key? key}) : super(key: key);
  ///
  ///   /// Something important this widget must do when pressed.
  ///   final VoidCallback? onPressed;
  ///
  ///   @override
  ///   State<MyWidget> createState() => MyWidgetState();
  /// }
  ///
  /// class MyWidgetState extends State<MyWidget> with WidgetEventMixin<MyWidget> {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Container(
  ///       color: isPressed ? Colors.black : Colors.white,
  ///       child: InkWell(
  ///         onHighlightChanged: updateWidgetEvent(
  ///           WidgetEvent.pressed,
  ///           onChanged: (bool val) {
  ///             if (val) {
  ///               widget.onPressed?.call();
  ///             }
  ///           },
  ///         ),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  /// {@end-tool}
  @protected
  ValueChanged<bool> updateWidgetEvent(
    WidgetEvent key, {
    ValueChanged<bool>? onChanged,
  }) {
    return (bool value) {
      if (widgetEvents.contains(key) == value) return;
      setWidgetEvent(key, value);
      onChanged?.call(value);
    };
  }

  /// Mutator to mark a [WidgetEvent] value as either active or inactive.
  @protected
  void setWidgetEvent(WidgetEvent state, bool isSet) {
    return isSet ? addWidgetEvent(state) : removeWidgetEvent(state);
  }

  /// Mutator to mark a [WidgetEvent] value as active.
  @protected
  void addWidgetEvent(WidgetEvent state) {
    if (widgetEvents.add(state)) {
      setState(() {});
      didChangeWidgetEvent();
    }
  }

  /// Mutator to mark a [WidgetEvent] value as inactive.
  @protected
  void removeWidgetEvent(WidgetEvent state) {
    if (widgetEvents.remove(state)) {
      setState(() {});
      didChangeWidgetEvent();
    }
  }

  /// Getter for whether this class considers [WidgetEvent.disabled] to be active.
  bool get isDisabled => widgetEvents.isDisabled;

  /// Getter for whether this class considers [WidgetEvent.dragged] to be active.
  bool get isDragged => widgetEvents.isDragged;

  /// Getter for whether this class considers [WidgetEvent.error] to be active.
  bool get isErrored => widgetEvents.isErrored;

  /// Getter for whether this class considers [WidgetEvent.focused] to be active.
  bool get isFocused => widgetEvents.isFocused;

  /// Getter for whether this class considers [WidgetEvent.hovered] to be active.
  bool get isHovered => widgetEvents.isHovered;

  /// Getter for whether this class considers [WidgetEvent.pressed] to be active.
  bool get isPressed => widgetEvents.isPressed;

  /// Getter for whether this class considers [WidgetEvent.selected] to be active.
  bool get isSelected => widgetEvents.isSelected;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Set<WidgetEvent>>(
      'widgetEvents',
      widgetEvents,
      defaultValue: <WidgetEvent>{},
    ));
  }
}
