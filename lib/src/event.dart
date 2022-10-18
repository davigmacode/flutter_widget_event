/// Interactive events that some of the widgets can take on when
/// receiving input from the user.
///
/// Some widgets track their current state in a `Set<WidgetEvent>`.
class WidgetEvent {
  const WidgetEvent(this.value);
  final String value;

  @override
  String toString() => 'WidgetEvent.$value';

  /// The state when the user drags their mouse cursor over the given widget.
  static const hovered = WidgetEvent('hovered');

  /// The state when the user navigates with the keyboard to a given widget.
  ///
  /// This can also sometimes be triggered when a widget is tapped. For example,
  /// when a [TextField] is tapped, it becomes [focused].
  static const focused = WidgetEvent('focused');

  /// The state when the user is actively pressing down on the given widget.
  static const pressed = WidgetEvent('pressed');

  /// The state when this widget is being dragged from one place to another by
  /// the user.
  static const dragged = WidgetEvent('dragged');

  /// The state when this item has been selected.
  ///
  /// This applies to things that can be toggled (such as chips and checkboxes)
  /// and things that are selected from a set of options (such as tabs and radio buttons).
  static const selected = WidgetEvent('selected');

  /// The state when this widget is disabled and cannot be interacted with.
  ///
  /// Disabled widgets should not respond to hover, focus, press, or drag
  /// interactions.
  static const disabled = WidgetEvent('disabled');

  /// The state when the widget has entered some form of invalid state.
  static const error = WidgetEvent('error');

  /// Checker for whether events considers [WidgetEvent.disabled] to be active.
  static bool isDisabled(Set<WidgetEvent> events) {
    return events.contains(WidgetEvent.disabled);
  }

  /// Checker for whether events considers [WidgetEvent.dragged] to be active.
  static bool isDragged(Set<WidgetEvent> events) {
    return events.contains(WidgetEvent.dragged);
  }

  /// Checker for whether events considers [WidgetEvent.error] to be active.
  static bool isErrored(Set<WidgetEvent> events) {
    return events.contains(WidgetEvent.error);
  }

  /// Checker for whether events considers [WidgetEvent.focused] to be active.
  static bool isFocused(Set<WidgetEvent> events) {
    return events.contains(WidgetEvent.focused);
  }

  /// Checker for whether events considers [WidgetEvent.hovered] to be active.
  static bool isHovered(Set<WidgetEvent> events) {
    return events.contains(WidgetEvent.hovered);
  }

  /// Checker for whether events considers [WidgetEvent.pressed] to be active.
  static bool isPressed(Set<WidgetEvent> events) {
    return events.contains(WidgetEvent.pressed);
  }

  /// Checker for whether events considers [WidgetEvent.selected] to be active.
  static bool isSelected(Set<WidgetEvent> events) {
    return events.contains(WidgetEvent.selected);
  }
}

/// Alias to Set<WidgetEvent>
typedef WidgetEvents = Set<WidgetEvent>;
