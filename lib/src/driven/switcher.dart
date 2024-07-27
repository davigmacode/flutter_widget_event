import 'package:flutter/material.dart';

import '../event.dart';
import '../property.dart';

class DrivenSwitcher extends Widget implements DrivenProperty<Widget> {
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
            return KeyedSubtree(
              key: const ValueKey('errored'),
              child: errored,
            );
          }
          if (disabled != null && WidgetEvent.isDisabled(events)) {
            return KeyedSubtree(
              key: const ValueKey('disabled'),
              child: disabled,
            );
          }
          if (loading != null && WidgetEvent.isLoading(events)) {
            return KeyedSubtree(
              key: const ValueKey('loading'),
              child: loading,
            );
          }
          if (dragged != null && WidgetEvent.isDragged(events)) {
            return KeyedSubtree(
              key: const ValueKey('dragged'),
              child: dragged,
            );
          }
          if (pressed != null && WidgetEvent.isPressed(events)) {
            return KeyedSubtree(
              key: const ValueKey('pressed'),
              child: pressed,
            );
          }
          if (hovered != null && WidgetEvent.isHovered(events)) {
            return KeyedSubtree(
              key: const ValueKey('hovered'),
              child: hovered,
            );
          }
          if (focused != null && WidgetEvent.isFocused(events)) {
            return KeyedSubtree(
              key: const ValueKey('focused'),
              child: focused,
            );
          }
          if (indeterminate != null && WidgetEvent.isIndeterminate(events)) {
            return KeyedSubtree(
              key: const ValueKey('indeterminate'),
              child: indeterminate,
            );
          }
          if (selected != null && WidgetEvent.isSelected(events)) {
            return KeyedSubtree(
              key: const ValueKey('selected'),
              child: selected,
            );
          }

          return KeyedSubtree(
            key: const ValueKey('fallback'),
            child: fallback,
          );
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
      child: resolver(events),
    );
  }

  @override
  Element createElement() {
    throw UnimplementedError();
  }
}
