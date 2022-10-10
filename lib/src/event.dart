/// Interactive events that some of the widgets can take on when
/// receiving input from the user.
///
/// Some widgets track their current state in a `Set<WidgetEvent>`.
class WidgetEvent {
  const WidgetEvent(this.value);
  final String value;

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
}

extension WidgetEventFlag on Set<WidgetEvent> {
  /// Getter for whether this class considers [WidgetEvent.disabled] to be active.
  bool get isDisabled => contains(WidgetEvent.disabled);

  /// Getter for whether this class considers [WidgetEvent.dragged] to be active.
  bool get isDragged => contains(WidgetEvent.dragged);

  /// Getter for whether this class considers [WidgetEvent.error] to be active.
  bool get isErrored => contains(WidgetEvent.error);

  /// Getter for whether this class considers [WidgetEvent.focused] to be active.
  bool get isFocused => contains(WidgetEvent.focused);

  /// Getter for whether this class considers [WidgetEvent.hovered] to be active.
  bool get isHovered => contains(WidgetEvent.hovered);

  /// Getter for whether this class considers [WidgetEvent.pressed] to be active.
  bool get isPressed => contains(WidgetEvent.pressed);

  /// Getter for whether this class considers [WidgetEvent.selected] to be active.
  bool get isSelected => contains(WidgetEvent.selected);
}
