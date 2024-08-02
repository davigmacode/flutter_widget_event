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
class WidgetEventController extends ChangeNotifier with Diagnosticable {
  /// Creates a new instance of [WidgetEventController].
  ///
  /// Optionally allows setting the initial state of the events.
  ///  * [value]: The initial set of active [WidgetEvent]s. Defaults to an empty set.
  ///  * [onChanged]: A callback that will be invoked whenever the set of active events changes.
  WidgetEventController([
    Set<WidgetEvent>? events,
    this.onChanged,
  ]) : value = events ?? {};

  /// Creates a new instance of [WidgetEventController] with a specific set of events.
  ///
  /// * [events]: The initial set of active `WidgetEvent`s.
  /// * [onChanged]: A callback invoked when the set of active events changes.
  ///   It takes a new set of events as a parameter and returns `void`.
  WidgetEventController.value(
    Set<WidgetEvent> events, {
    this.onChanged,
  }) : value = events;

  /// Creates a new instance of [WidgetEventController] based on a map of events.
  ///
  /// The map keys represent the [WidgetEvent]s and the map values represent
  /// the desired active state for each event (true for active, false for inactive).
  /// Events with a value of `false` in the map will be removed from the set.
  WidgetEventController.reg(
    Map<WidgetEvent, bool> registry, {
    this.onChanged,
  }) : value = (registry..removeWhere((key, value) => !value)).keys.toSet();

  /// Creates a new instance of [WidgetEventController].
  ///
  /// Optionally allows setting the initial state of the events.
  ///  * [focused]: Whether the widget is currently focused.
  ///  * [hovered]: Whether the widget is currently hovered.
  ///  * [pressed]: Whether the widget is currently pressed.
  ///  * [dragged]: Whether the widget is currently dragged.
  ///  * [selected]: Whether the widget is currently selected.
  ///  * [disabled]: Whether the widget is currently disabled.
  ///  * [indeterminate]: Whether the widget is currently indeterminate.
  ///  * [error]: Whether the widget is currently in an error state.
  ///  * [loading]: Whether the widget is currently loading.
  ///  * [onChanged]: A callback that will be invoked whenever the set of active events changes.
  WidgetEventController.by({
    bool focused = false,
    bool hovered = false,
    bool pressed = false,
    bool dragged = false,
    bool selected = false,
    bool indeterminate = false,
    bool disabled = false,
    bool error = false,
    bool loading = false,
    this.onChanged,
  }) : value = ({
          WidgetEvent.focused: focused,
          WidgetEvent.hovered: hovered,
          WidgetEvent.pressed: pressed,
          WidgetEvent.dragged: dragged,
          WidgetEvent.selected: selected,
          WidgetEvent.indeterminate: indeterminate,
          WidgetEvent.disabled: disabled,
          WidgetEvent.error: error,
          WidgetEvent.loading: loading,
        }..removeWhere((key, value) => !value))
            .keys
            .toSet();

  /// Called whenever the set of active [WidgetEvent]s changes.
  final ValueSetter<Set<WidgetEvent>>? onChanged;

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

  /// Getter for whether [WidgetEvent.hovered] to be active.
  bool get isHovered => WidgetEvent.isHovered(value);

  /// Getter for whether [WidgetEvent.focused] to be active.
  bool get isFocused => WidgetEvent.isFocused(value);

  /// Getter for whether [WidgetEvent.pressed] to be active.
  bool get isPressed => WidgetEvent.isPressed(value);

  /// Getter for whether [WidgetEvent.dragged] to be active.
  bool get isDragged => WidgetEvent.isDragged(value);

  /// Getter for whether [WidgetEvent.selected] to be active.
  bool get isSelected => WidgetEvent.isSelected(value);

  /// Getter for whether [WidgetEvent.indeterminate] to be active.
  bool get isIndeterminate => WidgetEvent.isIndeterminate(value);

  /// Getter for whether [WidgetEvent.disabled] to be active.
  bool get isDisabled => WidgetEvent.isDisabled(value);

  /// Getter for whether [WidgetEvent.error] to be active.
  bool get isErrored => WidgetEvent.isErrored(value);

  /// Getter for whether [WidgetEvent.loading] to be active.
  bool get isLoading => WidgetEvent.isLoading(value);

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
    }
  }

  /// Mutator to mark a [T] value as inactive.
  void remove(WidgetEvent event) {
    if (value.remove(event)) {
      notifyListeners();
    }
  }

  /// Updates the [value] set with a map of [WidgetEvent]s and their desired states.
  ///
  /// Events with a value of `true` in the map will be marked as active,
  /// while events with a value of `false` will be removed from the set.
  void update(Map<WidgetEvent, bool> registry) {
    registry.removeWhere((key, value) => !value);
    value = registry.keys.toSet();
    notifyListeners();
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

  @override
  void notifyListeners() {
    super.notifyListeners();
    onChanged?.call(value);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<WidgetEvent>('value', value));
    properties.add(DiagnosticsProperty<bool>('isDisabled', isDisabled));
    properties.add(DiagnosticsProperty<bool>('isDragged', isDragged));
    properties.add(DiagnosticsProperty<bool>('isErrored', isErrored));
    properties.add(DiagnosticsProperty<bool>('isFocused', isFocused));
    properties.add(DiagnosticsProperty<bool>('isHovered', isHovered));
    properties.add(DiagnosticsProperty<bool>('isPressed', isPressed));
    properties.add(DiagnosticsProperty<bool>('isSelected', isSelected));
  }
}
