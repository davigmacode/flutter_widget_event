import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'spinner_theme_data.dart';

/// A Widget that controls how descendant [DrivenSpinner]s should look like.
class DrivenSpinnerTheme extends InheritedTheme {
  /// The properties for descendant [DrivenSpinner]s
  final DrivenSpinnerThemeData data;

  /// Creates a theme that controls
  /// how descendant [DrivenSpinner]s should look like.
  const DrivenSpinnerTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Creates an [DrivenSpinnerTheme] that controls the style of
  /// descendant widgets, and merges in the current [DrivenSpinnerTheme], if any.
  ///
  /// The [style] and [child] arguments must not be null.
  static Widget merge({
    Key? key,
    double? size,
    Color? color,
    Color? backgroundColor,
    double? width,
    double? offset,
    bool? rounded,
    DrivenSpinnerThemeData? data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        final parent = DrivenSpinnerTheme.of(context);
        return DrivenSpinnerTheme(
          key: key,
          data: parent.merge(data).copyWith(
                size: size,
                color: color,
                backgroundColor: backgroundColor,
                width: width,
                offset: offset,
                rounded: rounded,
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
  /// DrivenSpinnerThemeData theme = DrivenSpinnerTheme.of(context);
  /// ```
  static DrivenSpinnerThemeData? maybeOf(BuildContext context) {
    final parentTheme =
        context.dependOnInheritedWidgetOfExactType<DrivenSpinnerTheme>();
    if (parentTheme != null) return parentTheme.data;

    final globalTheme = Theme.of(context).extension<DrivenSpinnerThemeData>();
    return globalTheme;
  }

  /// The [data] from the closest instance of
  /// this class that encloses the given context.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// DrivenSpinnerThemeData theme = DrivenSpinnerTheme.of(context);
  /// ```
  static DrivenSpinnerThemeData of(BuildContext context) {
    final parentTheme = DrivenSpinnerTheme.maybeOf(context);
    if (parentTheme != null) return parentTheme;

    return const DrivenSpinnerThemeData();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DrivenSpinnerTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(DrivenSpinnerTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('data', data));
  }
}
