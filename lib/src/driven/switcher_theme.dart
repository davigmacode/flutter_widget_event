import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'switcher_theme_data.dart';

/// A Widget that controls how descendant [DrivenSwitcher]s should look like.
class DrivenSwitcherTheme extends InheritedTheme {
  /// The properties for descendant [DrivenSwitcher]s
  final DrivenSwitcherThemeData data;

  /// Creates a theme that controls
  /// how descendant [DrivenSwitcher]s should look like.
  const DrivenSwitcherTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Creates an [DrivenSwitcherTheme] that controls the style of
  /// descendant widgets, and merges in the current [DrivenSwitcherTheme], if any.
  ///
  /// The [style] and [child] arguments must not be null.
  static Widget merge({
    Key? key,
    Duration? duration,
    Duration? reverseDuration,
    Curve? switchInCurve,
    Curve? switchOutCurve,
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    bool? maintainKey,
    DrivenSwitcherThemeData? data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        final parent = DrivenSwitcherTheme.of(context);
        return DrivenSwitcherTheme(
          key: key,
          data: parent.merge(data).copyWith(
                duration: duration,
                reverseDuration: reverseDuration,
                switchInCurve: switchInCurve,
                switchOutCurve: switchOutCurve,
                transitionBuilder: transitionBuilder,
                layoutBuilder: layoutBuilder,
                maintainKey: maintainKey,
              ),
          child: child,
        );
      },
    );
  }

  /// The [data] from the closest instance of
  /// this class that encloses the given context.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// DrivenSwitcherThemeData theme = DrivenSwitcherTheme.of(context);
  /// ```
  static DrivenSwitcherThemeData? maybeOf(BuildContext context) {
    final parentTheme =
        context.dependOnInheritedWidgetOfExactType<DrivenSwitcherTheme>();
    if (parentTheme != null) return parentTheme.data;

    final globalTheme = Theme.of(context).extension<DrivenSwitcherThemeData>();
    return globalTheme;
  }

  /// The [data] from the closest instance of
  /// this class that encloses the given context.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// DrivenSwitcherThemeData theme = DrivenSwitcherTheme.of(context);
  /// ```
  static DrivenSwitcherThemeData of(BuildContext context) {
    final parentTheme = DrivenSwitcherTheme.maybeOf(context);
    if (parentTheme != null) return parentTheme;

    return const DrivenSwitcherThemeData();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DrivenSwitcherTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(DrivenSwitcherTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('data', data));
  }
}
