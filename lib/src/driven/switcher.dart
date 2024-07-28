import 'package:flutter/material.dart';

import '../event.dart';
import '../property.dart';

/// A widget that switches between different child widgets based on events.
///
/// The `DrivenSwitcher` takes a `resolver` function that determines the child
/// widget to display based on the current events. It uses an `AnimatedSwitcher`
/// internally to animate the transitions between child widgets.
///
/// You can either provide a single fallback widget or define specific widgets
/// for different event states (e.g., errored, disabled, loading, etc.).
class DrivenSwitcher extends StatelessWidget implements DrivenProperty<Widget> {
  /// Creates a `DrivenSwitcher` with a provided resolver function.
  ///
  /// The `resolver` function takes the current events as input and returns the
  /// appropriate child widget to display.
  const DrivenSwitcher(
    this.resolver, {
    super.key,
    this.duration,
    this.reverseDuration,
    this.switchInCurve,
    this.switchOutCurve,
    this.transitionBuilder,
    this.layoutBuilder,
  });

  /// Creates a `DrivenSwitcher` with a fallback widget and optional widgets
  /// for different event states.
  ///
  /// This constructor allows you to specify a fallback widget to display when
  /// no specific event state matches. You can also provide widgets for various
  /// event states like errored, disabled, loading, etc.
  DrivenSwitcher.at(
    Widget fallback, {
    super.key,
    this.duration,
    this.reverseDuration,
    this.switchInCurve,
    this.switchOutCurve,
    this.transitionBuilder,
    this.layoutBuilder,
    Widget? errored,
    Widget? disabled,
    Widget? loading,
    Widget? dragged,
    Widget? pressed,
    Widget? hovered,
    Widget? focused,
    Widget? indeterminate,
    Widget? selected,
  }) : resolver = ((events) {
          if (errored != null && WidgetEvent.isErrored(events)) {
            return errored;
          }
          if (disabled != null && WidgetEvent.isDisabled(events)) {
            return disabled;
          }
          if (loading != null && WidgetEvent.isLoading(events)) {
            return loading;
          }
          if (dragged != null && WidgetEvent.isDragged(events)) {
            return dragged;
          }
          if (pressed != null && WidgetEvent.isPressed(events)) {
            return pressed;
          }
          if (hovered != null && WidgetEvent.isHovered(events)) {
            return hovered;
          }
          if (focused != null && WidgetEvent.isFocused(events)) {
            return focused;
          }
          if (indeterminate != null && WidgetEvent.isIndeterminate(events)) {
            return indeterminate;
          }
          if (selected != null && WidgetEvent.isSelected(events)) {
            return selected;
          }

          return fallback;
        });

  /// The resolver function that determines the child widget to display.
  final DrivenPropertyResolver<Widget> resolver;

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
    return AnimatedSwitcher(
      duration: duration ?? defaultDuration,
      reverseDuration: reverseDuration,
      switchInCurve: switchInCurve ?? Curves.linear,
      switchOutCurve: switchOutCurve ?? switchInCurve ?? Curves.linear,
      transitionBuilder: transitionBuilder ?? defaultTransitionBuilder,
      layoutBuilder: layoutBuilder ?? defaultLayoutBuilder,
      child: KeyedSubtree(
        key: ValueKey('DrivenSwitcher(${events.toString()})'),
        child: resolver(events),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return resolve({});
  }
}
