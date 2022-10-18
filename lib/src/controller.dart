import 'package:flutter/foundation.dart';
import 'event.dart';

/// Manages a set of [WidgetEvent]s and notifies listeners of changes.
///
/// Used by widgets that expose their internal event
/// for the sake of extensions that add support for additional events.
///
/// The controller's value is its current set of events.
/// Listeners are notified whenever the value changes.
/// The value should only be changed with update;
/// it should not be modified directly.
class WidgetEventController extends ChangeNotifier {
  WidgetEventController({
    bool selected = false,
    bool disabled = false,
    bool focused = false,
    bool hovered = false,
    bool pressed = false,
    bool dragged = false,
    bool error = false,
    Set<WidgetEvent>? events,
    this.onChanged,
  }) : value = <WidgetEvent>{
          if (selected) WidgetEvent.selected,
          if (disabled) WidgetEvent.disabled,
          if (focused) WidgetEvent.focused,
          if (hovered) WidgetEvent.hovered,
          if (pressed) WidgetEvent.pressed,
          if (dragged) WidgetEvent.dragged,
          if (error) WidgetEvent.error,
        }..addAll(events ?? {});

  /// Called when [value] changes.
  final VoidCallback? onChanged;

  /// Managed set of active [WidgetEvent] values;
  /// designed to be passed to [DrivenProperty.resolve] methods.
  ///
  /// To mutate and have [notifyListeners] called automatically for you,
  /// use [emit], [toggle], [add], or [remove].
  /// Directly mutating the set is possible, and may be necessary
  /// if you need to alter its list without calling [notifyListeners]
  /// (and thus triggering a re-render).
  ///
  /// To check for a single condition, convenience getters [isPressed], [isHovered],
  /// [isFocused], etc, are available for each [WidgetEvent] value.
  Set<WidgetEvent> value;

  /// Getter for whether [WidgetEvent.disabled] to be active.
  bool get isDisabled => WidgetEvent.isDisabled(value);

  /// Getter for whether [WidgetEvent.dragged] to be active.
  bool get isDragged => WidgetEvent.isDragged(value);

  /// Getter for whether [WidgetEvent.error] to be active.
  bool get isErrored => WidgetEvent.isErrored(value);

  /// Getter for whether [WidgetEvent.focused] to be active.
  bool get isFocused => WidgetEvent.isFocused(value);

  /// Getter for whether [WidgetEvent.hovered] to be active.
  bool get isHovered => WidgetEvent.isHovered(value);

  /// Getter for whether [WidgetEvent.pressed] to be active.
  bool get isPressed => WidgetEvent.isPressed(value);

  /// Getter for whether [WidgetEvent.selected] to be active.
  bool get isSelected => WidgetEvent.isSelected(value);

  /// Callback factory which accepts a [T] value and returns a
  /// closure to mutate [value] and call [setState].
  ///
  /// Accepts an optional second named parameter, `onChanged`, which allows
  /// arbitrary functionality to be wired through the [WidgetEventMixin].
  /// If supplied, the [onChanged] function is only called when child widgets
  /// report events that make changes to the current set of [WidgetEvent]s.
  ///
  /// {@tool snippet}
  /// This example shows how to use the [emit] callback factory
  /// in other widgets, including the optional [onChanged] callback.
  ///
  /// ```dart
  /// class MyWidget extends StatefulWidget {
  ///   const MyWidget({
  ///     Key? key,
  ///     this.onPressed,
  ///   }) : super(key: key);
  ///
  ///   /// Something important this widget must do when pressed.
  ///   final VoidCallback? onPressed;
  ///
  ///   final WidgetEventController? eventsController;
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
  ///         onHighlightChanged: widgetEvents.emit(
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
  ValueChanged<bool> emit(
    WidgetEvent event, {
    ValueChanged<bool>? onChanged,
  }) {
    return (bool value) {
      if (this.value.contains(event) == value) return;
      toggle(event, value);
      onChanged?.call(value);
    };
  }

  /// Mutator to mark a [T] value as either active or inactive.
  void toggle(WidgetEvent event, [bool? active]) {
    active = active ?? !value.contains(event);
    return active ? add(event) : remove(event);
  }

  /// Mutator to mark a [T] value as active.
  void add(WidgetEvent event) {
    if (value.add(event)) {
      notifyListeners();
      onChanged?.call();
    }
  }

  /// Mutator to mark a [T] value as inactive.
  void remove(WidgetEvent event) {
    if (value.remove(event)) {
      notifyListeners();
      onChanged?.call();
    }
  }

  /// Merge [value] with a new set of [WidgetEvent].
  void merge(Set<WidgetEvent> events) {
    value.addAll(events);
    notifyListeners();
  }

  /// Replace [value] with a new set of [WidgetEvent].
  void replace(Set<WidgetEvent> events) {
    value = events;
    notifyListeners();
  }

  /// Removes all elements from the [value].
  void clear() {
    value.clear();
    notifyListeners();
  }
}
