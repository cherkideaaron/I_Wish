import 'package:flutter/material.dart';

/// Centered circular loading indicator using the brand primary color.
///
/// Usage:
///   if (isLoading) const AppLoadingIndicator()
///   if (isLoading) AppLoadingIndicator(size: 32, color: Colors.white)
class AppLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const AppLoadingIndicator({
    super.key,
    this.size = 40,
    this.color,
    this.strokeWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          color: color ?? Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
