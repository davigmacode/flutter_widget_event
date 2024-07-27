import 'package:flutter/widgets.dart';

import '../event.dart';
import '../property.dart';

abstract class DrivenWidget<T extends Widget?> extends Widget
    implements DrivenProperty<T> {
  const DrivenWidget._({Key? key}) : super(key: key);

  @override
  T resolve(Set<WidgetEvent> events);

  static T evaluate<T extends Widget?>(T value, Set<WidgetEvent> events) {
    return DrivenProperty.evaluate<T>(value, events);
  }

  static DrivenWidget maybe(DrivenPropertyResolver<Widget?> callback) {
    return _DrivenWidget(callback);
  }

  static DrivenWidget<Widget> by(DrivenPropertyResolver<Widget> callback) {
    return _DrivenWidget<Widget>(callback);
  }

  static DrivenWidget<Widget> all(Widget value) {
    return _DrivenWidget<Widget>((events) => value);
  }
}

class _DrivenWidget<T extends Widget?> extends DrivenWidget<T> {
  _DrivenWidget(this._resolver) : super._(key: _resolver({})?.key);

  final DrivenPropertyResolver<T> _resolver;

  @override
  T resolve(Set<WidgetEvent> events) => _resolver(events);

  @override
  Element createElement() {
    throw UnimplementedError();
  }
}
