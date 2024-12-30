import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Widget? icon;
  final Color backgroundColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius; // Optional borderRadius
  final int elevation; // Elevation is now an int and optional

  // Constructor
  CustomElevatedButton({
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor = Colors.white, // Default background color
    this.textColor, // Optional text color
    this.textStyle, // Optional text style
    this.borderRadius = const BorderRadius.all(Radius.circular(30)), // Default borderRadius
    this.elevation = 10, // Default elevation
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // Button background color
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(30), // Rounded corners
        ),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Padding inside the button
        shadowColor: Colors.white, // Shadow color
        elevation: elevation.toDouble(), // Shadow height
        textStyle: textStyle ?? TextStyle( // Text style, if none provided, default style is used
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor ?? Colors.white, // Default text color is white
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            SizedBox(width: 10), // Space between icon and text
          ],
          Text(text),
        ],
      ),
    );
  }
}
