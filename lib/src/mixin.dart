import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'event.dart';
import 'controller.dart';

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
///   const MyWidget({
///     Key? key,
///     required this.color,
///     required this.child,
///   }) : super(key: key);
///
///   final Color color;
///   final Widget child;
///
///   @override
///   State<MyWidget> createState() => MyWidgetState();
/// }
///
/// class MyWidgetState extends State<MyWidget> with WidgetEventMixin<MyWidget> {
///
///   @override
///   void initState() {
///     super.initState();
///     initWidgetEvents();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return InkWell(
///       onFocusChange: widgetEvents.emit(WidgetEvent.focused),
///       child: Container(
///         color: DrivenProperty.evaluate<Color>(widget.color, widgetEvents.value),
///         child: widget.child,
///       ),
///     );
///   }
/// }
/// ```
/// {@end-tool}
@optionalTypeArgs
mixin WidgetEventMixin<T extends StatefulWidget> on State<T> {
  WidgetEventController? _internalController;
  WidgetEventController? _externalController;

  /// Manages a set of [WidgetEvent]s and notifies listeners of changes.
  WidgetEventController get widgetEvents {
    return _externalController ?? _internalController!;
  }

  /// Called when [widgetEvents] changes.
  @protected
  @mustCallSuper
  void didChangeWidgetEvents() {
    setState(() {});
  }

  /// Init widget events with external events controller
  ///
  /// @override
  /// void initState() {
  ///   super.initState();
  ///   initWidgetEvents(widget.eventsController);
  /// }
  @protected
  void initWidgetEvents([WidgetEventController? controller]) {
    if (controller != null) {
      _externalController = controller;
    } else {
      _internalController = WidgetEventController();
    }
    widgetEvents.addListener(didChangeWidgetEvents);
  }

  /// Update widget events with external events controller
  ///
  /// @override
  /// void didUpdateWidget(covariant MyWidget oldWidget) {
  ///   super.didUpdateWidget(oldWidget);
  ///   updateWidgetEvents(
  ///     oldWidget.eventController,
  ///     widget.eventController,
  ///   );
  /// }
  @protected
  void updateWidgetEvents(
    WidgetEventController? oldController,
    WidgetEventController? newController,
  ) {
    if (newController != oldController) {
      oldController?.removeListener(didChangeWidgetEvents);
      if (newController != null) {
        _internalController?.dispose();
        _internalController = null;
      }
      initWidgetEvents(newController);
    }
  }

  @protected
  void disposeWidgetEvents() {
    _externalController?.removeListener(didChangeWidgetEvents);
    _internalController?.dispose();
  }

  @override
  void initState() {
    super.initState();
    initWidgetEvents();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    disposeWidgetEvents();
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<WidgetEventController>(
      'widgetEvents',
      widgetEvents,
      defaultValue: null,
    ));
  }
}
