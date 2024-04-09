import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'event.dart';
import 'property.dart';

abstract class DrivenWidget extends Widget implements DrivenProperty<Widget> {
  const DrivenWidget({Key? key}) : super(key: key);

  @override
  Widget resolve(Set<WidgetEvent> events);

  static Widget evaluate(Widget value, Set<WidgetEvent> events) {
    return DrivenProperty.evaluate<Widget>(value, events);
  }

  static DrivenWidget by(DrivenPropertyResolver<Widget> callback) {
    return _DrivenWidget(callback);
  }

  static DrivenWidget all(Widget value) {
    return _DrivenWidget((events) => value);
  }
}

class _DrivenWidget extends DrivenWidget {
  _DrivenWidget(this._resolver) : super(key: _resolver({}).key);

  final DrivenPropertyResolver<Widget> _resolver;

  @override
  Widget resolve(Set<WidgetEvent> events) => _resolver(events);

  @override
  Element createElement() {
    throw UnimplementedError();
  }
}

abstract class DrivenColor extends Color implements DrivenProperty<Color> {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const DrivenColor(super.defaultValue);

  @override
  Color resolve(Set<WidgetEvent> events);

  static Color evaluate(Color value, Set<WidgetEvent> events) {
    return DrivenProperty.evaluate<Color>(value, events);
  }

  static DrivenColor by(DrivenPropertyResolver<Color> callback) {
    return _DrivenColor(callback);
  }

  static DrivenColor all(Color value) {
    return _DrivenColor((events) => value);
  }
}

class _DrivenColor extends DrivenColor {
  _DrivenColor(this._resolver) : super(_resolver({}).value);

  final DrivenPropertyResolver<Color> _resolver;

  @override
  Color resolve(Set<WidgetEvent> events) => _resolver(events);
}

/// Defines a [MouseCursor] whose value depends on a set of [WidgetEvent]s which
/// represent the interactive state of a component.
///
/// This kind of [MouseCursor] is useful when the set of interactive
/// actions a widget supports varies with its state. For example, a
/// mouse pointer hovering over a disabled [ListTile] should not
/// display [SystemMouseCursors.click], since a disabled list tile
/// doesn't respond to mouse clicks. [ListTile]'s default mouse cursor
/// is a [DrivenMouseCursor.clickable], which resolves to
/// [SystemMouseCursors.basic] when the button is disabled.
///
/// To use a [DrivenMouseCursor], you should create a subclass of
/// [DrivenMouseCursor] and implement the abstract `resolve` method.
///
/// {@tool dartpad}
/// This example defines a mouse cursor that resolves to
/// [SystemMouseCursors.forbidden] when its widget is disabled.
///
/// {@end-tool}
///
/// This class should only be used for parameters which are documented to take
/// [DrivenMouseCursor], otherwise only the default state will be used.
///
/// See also:
///
///  * [MouseCursor] for introduction on the mouse cursor system.
///  * [SystemMouseCursors], which defines cursors that are supported by
///    native platforms.
abstract class DrivenMouseCursor extends MouseCursor
    implements DrivenProperty<MouseCursor> {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const DrivenMouseCursor();

  @protected
  @override
  MouseCursorSession createSession(int device) {
    return resolve(<WidgetEvent>{}).createSession(device);
  }

  /// Returns a [MouseCursor] that's to be used when a Material component is in
  /// the specified state.
  ///
  /// This method should never return null.
  @override
  MouseCursor resolve(Set<WidgetEvent> states);

  /// A mouse cursor for clickable material widgets, which resolves differently
  /// when the widget is disabled.
  ///
  /// By default this cursor resolves to [SystemMouseCursors.click]. If the widget is
  /// disabled, the cursor resolves to [SystemMouseCursors.basic].
  ///
  /// This cursor is the default for many Material widgets.
  static const DrivenMouseCursor clickable = _WhenMouseCursor(
    enabledCursor: SystemMouseCursors.click,
    disabledCursor: SystemMouseCursors.basic,
    name: 'clickable',
  );

  /// A mouse cursor for material widgets related to text, which resolves differently
  /// when the widget is disabled.
  ///
  /// By default this cursor resolves to [SystemMouseCursors.text]. If the widget is
  /// disabled, the cursor resolves to [SystemMouseCursors.basic].
  ///
  /// This cursor is the default for many Material widgets.
  static const DrivenMouseCursor textable = _WhenMouseCursor(
    enabledCursor: SystemMouseCursors.text,
    disabledCursor: SystemMouseCursors.basic,
    name: 'textable',
  );
}

class _WhenMouseCursor extends DrivenMouseCursor {
  const _WhenMouseCursor({
    required this.enabledCursor,
    required this.disabledCursor,
    required this.name,
  });

  final MouseCursor enabledCursor;
  final MouseCursor disabledCursor;
  final String name;

  @override
  MouseCursor resolve(Set<WidgetEvent> states) {
    if (states.contains(WidgetEvent.disabled)) {
      return disabledCursor;
    }
    return enabledCursor;
  }

  @override
  String get debugDescription => 'DrivenMouseCursor($name)';
}
