import 'package:flutter/material.dart';

import '../event.dart';
import '../property.dart';

class DrivenSwitcher extends StatelessWidget implements DrivenProperty<Widget> {
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

  final DrivenPropertyResolver<Widget> resolver;

  final Duration? duration;

  final Duration? reverseDuration;

  final Curve? switchInCurve;

  final Curve? switchOutCurve;

  final AnimatedSwitcherTransitionBuilder? transitionBuilder;

  final AnimatedSwitcherLayoutBuilder? layoutBuilder;

  static const defaultDuration = Duration(milliseconds: 200);

  static const defaultTransitionBuilder =
      AnimatedSwitcher.defaultTransitionBuilder;

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
        key: ValueKey(events.toString()),
        child: resolver(events),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return resolve({});
  }
}
