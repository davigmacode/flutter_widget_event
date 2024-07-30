import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Defines the visual properties of [DrivenSpinner].
///
/// Descendant widgets obtain the current [DrivenSpinnerThemeData] object using
/// `DrivenSpinnerTheme.of(context)`. Instances of [DrivenSpinnerThemeData]
/// can be customized with [DrivenSpinnerThemeData.copyWith] or [DrivenSpinnerThemeData.merge].
class DrivenSpinnerThemeData extends ThemeExtension<DrivenSpinnerThemeData>
    with Diagnosticable {
  /// The size of the spinner.
  final double? size;

  /// The color of the spinner.
  final Color? color;

  /// The background color of the spinner.
  final Color? backgroundColor;

  /// The width of the spinner's stroke.
  final double width;

  /// The offset of the spinner's stroke.
  final double offset;

  /// Whether the spinner's stroke is rounded.
  final bool rounded;

  /// Creates a theme data that can be used for [DrivenSpinnerTheme].
  const DrivenSpinnerThemeData({
    this.size,
    this.color,
    this.backgroundColor,
    this.width = 4,
    this.offset = 0,
    this.rounded = true,
  });

  /// Creates a [DrivenSpinnerThemeData] from another one that probably null.
  DrivenSpinnerThemeData.from([
    DrivenSpinnerThemeData? other,
    DrivenSpinnerThemeData fallback = const DrivenSpinnerThemeData(),
  ])  : size = other?.size ?? fallback.size,
        color = other?.color ?? fallback.color,
        backgroundColor = other?.backgroundColor ?? fallback.backgroundColor,
        width = other?.width ?? fallback.width,
        offset = other?.offset ?? fallback.offset,
        rounded = other?.rounded ?? fallback.rounded;

  /// Creates a copy of this [DrivenSpinnerThemeData] but with
  /// the given fields replaced with the new values.
  @override
  DrivenSpinnerThemeData copyWith({
    double? size,
    Color? color,
    Color? backgroundColor,
    double? width,
    double? offset,
    bool? rounded,
  }) {
    return DrivenSpinnerThemeData(
      size: size ?? this.size,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      width: width ?? this.width,
      offset: offset ?? this.offset,
      rounded: rounded ?? this.rounded,
    );
  }

  /// Creates a copy of this [DrivenSpinnerThemeData] but with
  /// the given fields replaced with the new values.
  DrivenSpinnerThemeData merge(DrivenSpinnerThemeData? other) {
    // if null return current object
    if (other == null) return this;

    return copyWith(
      size: other.size,
      color: other.color,
      backgroundColor: other.backgroundColor,
      width: other.width,
      offset: other.offset,
      rounded: other.rounded,
    );
  }

  @override
  DrivenSpinnerThemeData lerp(DrivenSpinnerThemeData? other, double t) {
    if (other is! DrivenSpinnerThemeData) return this;
    return DrivenSpinnerThemeData(
      size: lerpDouble(size, other.size, t),
      color: Color.lerp(color, other.color, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      width: lerpDouble(width, other.width, t) ?? width,
      offset: lerpDouble(offset, other.offset, t) ?? offset,
      rounded: t < 0.5 ? rounded : other.rounded,
    );
  }

  Map<String, dynamic> toMap() => {
        'size': size,
        'color': color,
        'backgroundColor': backgroundColor,
        'width': width,
        'offset': offset,
        'rounded': rounded,
      };

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is DrivenSpinnerThemeData && mapEquals(other.toMap(), toMap());
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
