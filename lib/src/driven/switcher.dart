import 'package:flutter/widgets.dart';
import '../event.dart';
import '../property.dart';
import 'child.dart';

/// A widget that switches between child widgets based on events,
/// with animations.
///
/// `DrivenSwitcher` inherits from `DrivenChild<Widget>` and utilizes an
/// `AnimatedSwitcher` internally to provide animated transitions between
/// child widgets based on the current events. You can define different child
/// widgets for various event states (e.g., error, disabled, loading, etc.)
/// using the constructor parameters inherited from `DrivenChild`.
class DrivenSwitcher extends DrivenChild<Widget> {
  /// Creates a `DrivenSwitcher` with the provided child widgets for different
  /// event states and optional animation parameters.
  ///
  /// This constructor inherits all parameters from `DrivenChild` for defining
  /// child widgets based on events. Additionally, you can specify:
  ///  * `duration`: The duration of the switch animation.
  ///  * `reverseDuration`: The duration of the reverse switch animation.
  ///  * `switchInCurve`: The curve used for the switch-in animation.
  ///  * `switchOutCurve`: The curve used for the switch-out animation.
  ///  * `transitionBuilder`: A custom builder function for the switch animation.
  ///  * `layoutBuilder`: A custom builder function for the layout of the AnimatedSwitcher.
  ///  * `maintainKey`: Whether to maintain a key for the child widget during switching (defaults to true).
  const DrivenSwitcher(
    super.enabled, {
    super.atError,
    super.atDisabled,
    super.atLoading,
    super.atDragged,
    super.atPressed,
    super.atHovered,
    super.atFocused,
    super.atIndeterminate,
    super.atSelected,
    super.custom,
    super.key,
    this.duration,
    this.reverseDuration,
    this.switchInCurve,
    this.switchOutCurve,
    this.transitionBuilder,
    this.layoutBuilder,
    this.maintainKey = true,
  }) : super();

  /// Creates a `DrivenSwitcher` with a map of custom event-widget associations
  /// to map events to child widgets and optional animation parameters.
  ///
  /// This constructor inherits the event-to-child mapping functionality from
  /// `DrivenChild.map` and allows specifying additional animation parameters
  /// similar to the main constructor.
  const DrivenSwitcher.map(
    super.enabled,
    super.custom, {
    super.key,
    this.duration,
    this.reverseDuration,
    this.switchInCurve,
    this.switchOutCurve,
    this.transitionBuilder,
    this.layoutBuilder,
    this.maintainKey = true,
  }) : super.map();

  /// Creates a `DrivenSwitcher` from a callback function that resolves the child
  /// widget based on events.
  factory DrivenSwitcher.by(DrivenPropertyResolver<Widget> callback) {
    return DrivenSwitcherResolver(callback);
  }

  /// Whether to maintain a key for the child widget during switching.
  ///
  /// Defaults to `true` to preserve state across transitions. Setting this
  /// to `false` can improve performance but might cause issues if state needs
  /// to be maintained between child widgets.
  final bool maintainKey;

  /// The duration of the switch animation.
  final Duration? duration;

  /// The duration of the reverse switch animation.
  final Duration? reverseDuration;

  /// The curve used for the switch-in animation.
  final Curve? switchInCurve;

  /// The curve used for the switch-out animation.
  final Curve? switchOutCurve;

  /// The builder function used to customize the switch animation.
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;

  /// The builder function used to customize the layout of the AnimatedSwitcher.
  final AnimatedSwitcherLayoutBuilder? layoutBuilder;

  /// The default duration for the switch animation.
  static const defaultDuration = Duration(milliseconds: 200);

  /// The default transition builder for the AnimatedSwitcher.
  static const defaultTransitionBuilder =
      AnimatedSwitcher.defaultTransitionBuilder;

  /// The default layout builder for the AnimatedSwitcher.
  static const defaultLayoutBuilder = AnimatedSwitcher.defaultLayoutBuilder;

  @override
  Widget resolve(events) {
    Widget result = super.resolve(events);

    if (maintainKey) {
      result = KeyedSubtree(
        key: ValueKey('DrivenSwitcher(${events.toString()})'),
        child: result,
      );
    }

    return AnimatedSwitcher(
      duration: duration ?? defaultDuration,
      reverseDuration: reverseDuration,
      switchInCurve: switchInCurve ?? Curves.linear,
      switchOutCurve: switchOutCurve ?? switchInCurve ?? Curves.linear,
      transitionBuilder: transitionBuilder ?? defaultTransitionBuilder,
      layoutBuilder: layoutBuilder ?? defaultLayoutBuilder,
      child: result,
    );
  }

  @override
  Widget build(BuildContext context) {
    return resolve({});
  }
}

class DrivenSwitcherResolver extends DrivenSwitcher {
  /// Creates a `DrivenSwitcherResolver` from a provided resolver function.
  ///
  /// This class provides a way to dynamically resolve the child widget based on
  /// the given events using a custom resolver function.
  DrivenSwitcherResolver(
    this.resolver, {
    super.key,
    super.maintainKey = false,
  }) : super(resolver({}));

  /// The resolver function that determines the child widget based on events.
  final DrivenPropertyResolver<Widget> resolver;

  @override
  Widget resolve(events) => resolver(events);

  /// Evaluates a given value based on the provided events.
  ///
  /// This static method delegates the evaluation to the `DrivenProperty.evaluate` method.
  static T evaluate<T extends Widget?>(T value, Set<WidgetEvent> events) {
    return DrivenProperty.evaluate<T>(value, events);
  }
}
