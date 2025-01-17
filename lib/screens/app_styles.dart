import 'package:flutter/material.dart';

class AppStyles {
  static const Color primaryColor = Colors.blueAccent;
  static Color backgroundColor = Colors.grey[100]!;
  static const Color textColor = Colors.white;

  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 32, vertical: 12);

  static const TextStyle appBarTextStyle = TextStyle(color: textColor);
  static const TextStyle profileTextStyle = TextStyle(fontSize: 18);
  static const TextStyle buttonTextStyle = TextStyle(color: textColor);


  static const TextStyle titleTextStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const TextStyle subtitleTextStyle = TextStyle(fontSize: 18, color: Colors.grey);


  static const EdgeInsets cardPadding = EdgeInsets.all(8.0);


  static InputDecoration inputDecoration({
    required String labelText,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(icon, color: primaryColor),
    );
  }
}