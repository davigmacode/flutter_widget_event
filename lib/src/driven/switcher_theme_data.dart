import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Defines the visual properties of [DrivenSwitcher].
///
/// Descendant widgets obtain the current [DrivenSwitcherThemeData] object using
/// `DrivenSwitcherTheme.of(context)`. Instances of [DrivenSwitcherThemeData]
/// can be customized with [DrivenSwitcherThemeData.copyWith] or [DrivenSwitcherThemeData.merge].
class DrivenSwitcherThemeData extends ThemeExtension<DrivenSwitcherThemeData>
    with Diagnosticable {
  /// Whether the switcher's stroke is rounded.
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

  /// The default transition builder for the DrivenSwitcher.
  static const defaultTransitionBuilder =
      AnimatedSwitcher.defaultTransitionBuilder;

  /// The default layout builder for the DrivenSwitcher.
  static const defaultLayoutBuilder = AnimatedSwitcher.defaultLayoutBuilder;

  /// Creates a theme data that can be used for [DrivenSwitcherTheme].
  const DrivenSwitcherThemeData({
    this.duration,
    this.reverseDuration,
    this.switchInCurve,
    this.switchOutCurve,
    this.transitionBuilder,
    this.layoutBuilder,
    this.maintainKey = true,
  });

  /// Creates a [DrivenSwitcherThemeData] from another one that probably null.
  DrivenSwitcherThemeData.from([
    DrivenSwitcherThemeData? other,
    DrivenSwitcherThemeData fallback = const DrivenSwitcherThemeData(),
  ])  : duration = other?.duration ?? fallback.duration,
        reverseDuration = other?.reverseDuration ?? fallback.reverseDuration,
        switchInCurve = other?.switchInCurve ?? fallback.switchInCurve,
        switchOutCurve = other?.switchOutCurve ?? fallback.switchOutCurve,
        transitionBuilder =
            other?.transitionBuilder ?? fallback.transitionBuilder,
        layoutBuilder = other?.layoutBuilder ?? fallback.layoutBuilder,
        maintainKey = other?.maintainKey ?? fallback.maintainKey;

  /// Creates a copy of this [DrivenSwitcherThemeData] but with
  /// the given fields replaced with the new values.
  @override
  DrivenSwitcherThemeData copyWith({
    Duration? duration,
    Duration? reverseDuration,
    Curve? switchInCurve,
    Curve? switchOutCurve,
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
    bool? maintainKey,
  }) {
    return DrivenSwitcherThemeData(
      duration: duration ?? this.duration,
      reverseDuration: reverseDuration ?? this.reverseDuration,
      switchInCurve: switchInCurve ?? this.switchInCurve,
      switchOutCurve: switchOutCurve ?? this.switchOutCurve,
      transitionBuilder: transitionBuilder ?? this.transitionBuilder,
      layoutBuilder: layoutBuilder ?? this.layoutBuilder,
      maintainKey: maintainKey ?? this.maintainKey,
    );
  }

  /// Creates a copy of this [DrivenSwitcherThemeData] but with
  /// the given fields replaced with the new values.
  DrivenSwitcherThemeData merge(DrivenSwitcherThemeData? other) {
    // if null return current object
    if (other == null) return this;

    return copyWith(
      duration: other.duration,
      reverseDuration: other.reverseDuration,
      switchInCurve: other.switchInCurve,
      switchOutCurve: other.switchOutCurve,
      transitionBuilder: other.transitionBuilder,
      layoutBuilder: other.layoutBuilder,
      maintainKey: other.maintainKey,
    );
  }

  @override
  DrivenSwitcherThemeData lerp(DrivenSwitcherThemeData? other, double t) {
    if (other is! DrivenSwitcherThemeData) return this;
    return DrivenSwitcherThemeData(
      duration: t < 0.5 ? duration : other.duration,
      reverseDuration: t < 0.5 ? reverseDuration : other.reverseDuration,
      switchInCurve: t < 0.5 ? switchInCurve : other.switchInCurve,
      switchOutCurve: t < 0.5 ? switchOutCurve : other.switchOutCurve,
      transitionBuilder: t < 0.5 ? transitionBuilder : other.transitionBuilder,
      layoutBuilder: t < 0.5 ? layoutBuilder : other.layoutBuilder,
      maintainKey: t < 0.5 ? maintainKey : other.maintainKey,
    );
  }

  Map<String, dynamic> toMap() => {
        'duration': duration,
        'reverseDuration': reverseDuration,
        'switchInCurve': switchInCurve,
        'switchOutCurve': switchOutCurve,
        'transitionBuilder': transitionBuilder,
        'layoutBuilder': layoutBuilder,
        'maintainKey': maintainKey,
      };

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is DrivenSwitcherThemeData &&
        mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => Object.hashAll(toMap().values);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    toMap().entries.forEach((el) {
      properties.add(DiagnosticsProperty(el.key, el.value, defaultValue: null));
    });
  }
}
