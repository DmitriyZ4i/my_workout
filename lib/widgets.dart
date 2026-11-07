import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
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

  const MyButton({
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
          'MyButton must have at least text or icon',
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

class MyRoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;
  final double borderWidth;
  final double size;
  final double? iconSize;

  const MyRoundButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.borderColor,
    this.borderWidth = 1.0,
    required this.size,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderColor = borderColor ?? theme.colorScheme.outline;
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;

    return SizedBox(
      width: size,
      height: size,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.transparent,
          padding: EdgeInsets.zero,
          side: BorderSide(
            color: effectiveBorderColor,
            width: borderWidth,
          ),
          shape: const CircleBorder(),
        ),
        onPressed: onPressed,
        child: Icon(
          icon,
          size: iconSize ?? (size * 0.45),
          color: effectiveIconColor,
        ),
      ),
    );
  }
}
