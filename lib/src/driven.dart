import 'event.dart';
import 'property.dart';

import 'dart:ui';

abstract class DrivenColor extends Color implements DrivenProperty<Color> {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const DrivenColor(int defaultValue) : super(defaultValue);

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

extension ColorDriven on Color {
  static DrivenColor driven(DrivenPropertyResolver<Color> callback) {
    return DrivenColor.by(callback);
  }
}
