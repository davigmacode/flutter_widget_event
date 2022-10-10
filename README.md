![Pub Version](https://img.shields.io/pub/v/widget_event) ![GitHub](https://img.shields.io/github/license/davigmacode/flutter_widget_event)

<a href="https://www.buymeacoffee.com/davigmacode" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" width="195" height="55"></a>

Just like MaterialState but with convenient name and more spices.

## Features

* Convenient name
* Extendable event
* More helpers

## Usage

To read more about classes and other references used by `widget_event`, see the [API Reference](https://pub.dev/documentation/widget_event/latest/).

```dart
// Let's say, we have a custom widget with custom [style] property, we want to dynamically change the [style] value when some event happen on the widget, for example on pressed

class MyStyle {
  const MyStyle({
    this.color = Colors.blue,
    this.opacity = 1,
  });

  final Color color;
  final double opacity;
}

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

class MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: style?.color ?? Colors.red,
      child: TextField(
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
```

```dart
// The fastest way to achieve that is to change [MyStyle?] to [DrivenProperty<MyStyle?>?], and use [WidgetEventMixin] with [MyWidgetState] to watch [WidgetEvent] values.

class MyWidget extends StatefulWidget {
  const MyWidget({
    Key? key,
    this.style,
    this.onPressed,
  }) : super(key: key);

  final DrivenProperty<MyStyle?>? style;
  final VoidCallback? onPressed;

  @override
  State<MyWidget> createState() => MyWidgetState();
}

class MyWidgetState extends State<MyWidget> with WidgetEventMixin<MyWidget> {
  @override
  Widget build(BuildContext context) {
    final MyStyle? style = widget.style?.resolve(widgetEvents);
    return Container(
      color: style?.color ?? Colors.red,
      child: TextField(
        onTap: () {
          setWidgetEvent(WidgetEvent.pressed, true);
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

// Then we can fill [style] with event driven value
final myWidget = MyWidget(
  style: DrivenProperty.by<MyStyle?>((events) {
    if (events.isPressed) {
      return const MyStyle(color: Colors.amber);
    }
    return null;
  }),
);

// But we can't fill [style] with [MyStyle] directly anymore
final myWidget = MyWidget(
  // this will raise a type check error
  style: const MyStyle(color: Colors.amber),
);

// Once more the fastest way to fill [style] with a single value for all events is
final myWidget = MyWidget(
  style: DrivenProperty.all<MyStyle?>(const MyStyle(color: Colors.amber)),
);
```

```dart
// What if we want the event driven [style] and we want to directly fill the [style] with [MyStyle] too, so just create a custom [DrivenProperty]

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

// Also we can add helpers to [MyStyle]
class MyStyle {
  const MyStyle({
    this.color = Colors.blue,
    this.opacity = 1,
  });

  final Color color;
  final double opacity;

  static DrivenMyStyle driven(DrivenPropertyResolver<MyStyle?> callback) {
    return DrivenMyStyle.by(callback);
  }
}

// And finally a little modification on the [MyWidget] to evaluate value from [MyStyle] or [DrivenMyStyle]
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
        onTap: () {
          setWidgetEvent(WidgetEvent.pressed, true);
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

// Finally we can directly fill with [MyStyle]
final myWidget = MyWidget(
  style: const MyStyle(color: Colors.amber),
);

// Or with event driven value
final myWidget = MyWidget(
  style: MyStyle.driven((events) {
    if (events.isPressed) {
      return const MyStyle(color: Colors.amber);
    }
    return null;
  }),
);
```

```dart
// Wait, but how if we need a custom event, here is the recipes

class MyWidgetEvent extends WidgetEvent {
  const MyWidgetEvent(String value) : super(value);

  static const edited = MyWidgetEvent('edited');

  static bool isEdited(Set<WidgetEvent> events) {
    return events.contains(MyWidgetEvent.edited);
  }
}

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
        onTap: () {
          setWidgetEvent(WidgetEvent.pressed, true);
        },
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
```