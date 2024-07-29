import 'package:flutter/material.dart';

import '../event.dart';
import 'child.dart';

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
    this.width = 2,
    this.offset = 0,
    this.rounded = true,
  }) : super(null);

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

  @override
  get loading {
    return SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator(
        strokeWidth: width,
        strokeAlign: offset,
        strokeCap: rounded ? StrokeCap.round : StrokeCap.square,
        color: color,
        backgroundColor: backgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return resolve({WidgetEvent.loading})!;
  }
}
