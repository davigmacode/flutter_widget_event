import 'package:flutter/material.dart';

import '../event.dart';
import '../property.dart';
import 'widget.dart';

/// A circular spinner that can be driven by a `DrivenWidget`.
///
/// Displays a circular progress indicator when the associated `DrivenWidget`
/// indicates loading state.
class DrivenSpinner extends StatelessWidget implements DrivenProperty<Widget> {
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

  /// Creates a `DrivenWidget` that conditionally displays a `DrivenSpinner`.
  ///
  /// Returns a `DrivenWidget` that will display a `DrivenSpinner` if the associated
  /// `events` indicate loading state. Otherwise, returns null.
  static DrivenWidget<Widget?> maybe({
    Key? key,
    double? size = 16,
    Color? color,
    Color? backgroundColor,
    double width = 2,
    double offset = 0,
    bool rounded = true,
  }) {
    return DrivenWidget.maybe((events) {
      return WidgetEvent.isLoading(events)
          ? DrivenSpinner(
              key: key,
              size: size,
              color: color,
              backgroundColor: backgroundColor,
              width: width,
              offset: offset,
              rounded: rounded,
            )
          : null;
    });
  }

  @override
  Widget resolve(events) {
    return WidgetEvent.isLoading(events)
        ? Builder(builder: (context) => build(context))
        : SizedBox(key: key);
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
