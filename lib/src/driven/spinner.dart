import 'package:flutter/material.dart';

import '../event.dart';
import '../property.dart';

/// A circular spinner that can be driven by a `DrivenWidget`.
///
/// Displays a circular progress indicator when the associated `DrivenWidget`
/// indicates loading state.
class DrivenSpinner extends StatelessWidget implements DrivenProperty<Widget?> {
  /// Creates a `DrivenSpinner`.
  const DrivenSpinner({
    super.key,
    this.size,
    this.color,
    this.backgroundColor,
    this.width = 2,
    this.offset = 0,
    this.rounded = true,
  });

  @override
  Widget? resolve(events) {
    return WidgetEvent.isLoading(events)
        ? Builder(builder: (context) => build(context))
        : null;
  }

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
  Widget build(BuildContext context) {
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
}
