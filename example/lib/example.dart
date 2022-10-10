import 'package:flutter/material.dart';
import 'package:widget_event/widget_event.dart';

// Custom event
class MyWidgetEvent extends WidgetEvent {
  const MyWidgetEvent(String value) : super(value);

  static const edited = MyWidgetEvent('edited');

  static bool isEdited(Set<WidgetEvent> events) {
    return events.contains(MyWidgetEvent.edited);
  }
}

// Custom property
class MyStyle {
  const MyStyle({
    this.color = Colors.blue,
    this.opacity = 1,
  });

  final Color color;
  final double opacity;

  static MyStyle? evaluate(MyStyle? value, Set<WidgetEvent> events) {
    return DrivenMyStyle.evaluate(value, events);
  }

  static DrivenMyStyle driven(DrivenPropertyResolver<MyStyle?> callback) {
    return DrivenMyStyle.by(callback);
  }
}

// Custom Driven Property
abstract class DrivenMyStyle extends MyStyle
    implements DrivenProperty<MyStyle?> {
  const DrivenMyStyle();

  @override
  MyStyle? resolve(Set<WidgetEvent> events);

  static MyStyle? evaluate(MyStyle? value, Set<WidgetEvent> events) {
    return DrivenProperty.evaluate<MyStyle?>(value, events);
  }

  static DrivenMyStyle by(DrivenPropertyResolver<MyStyle?> callback) {
    return _DrivenMyStyle(callback);
  }

  static DrivenMyStyle all(MyStyle? value) {
    return _DrivenMyStyle((events) => value);
  }
}

class _DrivenMyStyle extends DrivenMyStyle {
  _DrivenMyStyle(this._resolver) : super();

  final DrivenPropertyResolver<MyStyle?> _resolver;

  @override
  MyStyle? resolve(Set<WidgetEvent> events) => _resolver(events);
}

// Custom widget with event driven property
class MyWidget extends StatefulWidget {
  const MyWidget({
    Key? key,
    this.style,
    this.onPressed,
  }) : super(key: key);

  final MyStyle? style;
  final VoidCallback? onPressed;

  @override
  State<MyWidget> createState() => MyWidgetState();
}

class MyWidgetState extends State<MyWidget> with WidgetEventMixin<MyWidget> {
  @override
  Widget build(BuildContext context) {
    final MyStyle? style = MyStyle.evaluate(widget.style, widgetEvents);
    return Container(
      color: style?.color ?? Colors.red,
      child: TextField(
        onChanged: (value) {
          setWidgetEvent(MyWidgetEvent.edited, true);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: style?.color ?? Colors.black54,
            ),
          ),
          label: const Text('Password'),
        ),
      ),
    );
  }
}

final myWidget = MyWidget(
  style: MyStyle.driven((events) {
    if (MyWidgetEvent.isEdited(events)) {
      return const MyStyle(color: Colors.amber);
    }
    return null;
  }),
);
