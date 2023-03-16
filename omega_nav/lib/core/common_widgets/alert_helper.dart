import 'package:flutter/material.dart';
import 'package:omega_nav/core/common_widgets/space_helpers.dart';

///Displays a [SnackBar] widget with red background.
void _displaySnackBarParent(BuildContext context, String message,
    Color textColor, Color bgColor, int duration, Widget fillWidget) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: Duration(seconds: duration),
    content: Row(
      children: [
        fillWidget,
        addHorizontalSpace(20),
        Text(message, style: TextStyle(color: textColor, fontSize: 14)),
      ],
    ),
    backgroundColor: bgColor,
  ));
}

void displayLoadingSnackBarMessage(
    BuildContext context, String message, Color textColor, Color bgColor) {
  _displaySnackBarParent(context, message, textColor, bgColor, 5,
      SizedBox(height: 24, width: 24 ,child: CircularProgressIndicator(color: textColor)));
}

void displayAlertSnackBarMessage(
    BuildContext context, String message, Color textColor, Color bgColor) {
  _displaySnackBarParent(context, message, textColor, bgColor, 4,
      Icon(Icons.close, size: 24, color: textColor));
}

void displaySnackBarMessage(
    BuildContext context, String message, Color textColor, Color bgColor) {
  _displaySnackBarParent(context, message, textColor, bgColor, 4, Container());
}

void dismissSnackBarMessage(BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
}
