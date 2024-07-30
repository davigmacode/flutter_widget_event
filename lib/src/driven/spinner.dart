import 'package:flutter/material.dart';

import '../event.dart';
import 'child.dart';
import 'spinner_theme.dart';

/// A circular spinner that can be driven by a `DrivenWidget`.
///
/// Displays a circular progress indicator when the associated `DrivenWidget`
/// indicates loading state.
class DrivenSpinner extends DrivenChild<Widget?> {
  /// Creates a `DrivenSpinner`.
  const DrivenSpinner({
    super.key,
    this.size,
    this.color,
    this.backgroundColor,
    this.width,
    this.offset,
    this.rounded,
  }) : super(null);

  /// The size of the spinner.
  final double? size;

  /// The color of the spinner.
  final Color? color;

  /// The background color of the spinner.
  final Color? backgroundColor;

  /// The width of the spinner's stroke.
  final double? width;

  /// The offset of the spinner's stroke.
  final double? offset;

  /// Whether the spinner's stroke is rounded.
  final bool? rounded;

  @override
  get atLoading {
    return Builder(builder: (context) {
      final theme = DrivenSpinnerTheme.of(context);
      final effectiveSize = size ?? theme.size;
      final effectiveWidth = width ?? theme.width;
      final effectiveOffset = offset ?? theme.offset;
      final effectiveRounded = rounded ?? theme.rounded;
      final effectiveColor = color ?? theme.color;
      final effectiveBackgroundColor = backgroundColor ?? theme.backgroundColor;
      return SizedBox.square(
        dimension: effectiveSize,
        child: CircularProgressIndicator(
          strokeWidth: effectiveWidth,
          strokeAlign: effectiveOffset,
          strokeCap: effectiveRounded ? StrokeCap.round : StrokeCap.square,
          color: effectiveColor,
          backgroundColor: effectiveBackgroundColor,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return resolve({WidgetEvent.loading})!;
  }
}
