import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double borderRadius;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;

  const AppButton({
    super.key,
    this.text,
    this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius = 8.0,
    this.borderWidth = 1.0,
    this.padding,
    this.iconSize,
  }) : assert(
          text != null || icon != null,
          'AppButton must have at least text or icon',
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderColor = borderColor ?? theme.colorScheme.outline;
    final effectiveTextColor = textColor ?? theme.colorScheme.primary;

    Widget childWidget;

    if (icon != null && text != null) {
      childWidget = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize ?? 20,
            color: effectiveTextColor,
          ),
          const SizedBox(width: 8),
          Text(
            text!,
            style: TextStyle(
              color: effectiveTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    } else if (icon != null) {
      childWidget = Icon(
        icon,
        size: iconSize ?? 22,
        color: effectiveTextColor,
      );
    } else {
      childWidget = Text(
        text!,
        style: TextStyle(
          color: effectiveTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    final effectivePadding = padding ??
        (icon != null && text == null
            ? const EdgeInsets.all(12)
            : const EdgeInsets.symmetric(horizontal: 20, vertical: 12));

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.transparent,
        padding: effectivePadding,
        side: BorderSide(
          color: effectiveBorderColor,
          width: borderWidth,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      child: childWidget,
    );
  }
}
