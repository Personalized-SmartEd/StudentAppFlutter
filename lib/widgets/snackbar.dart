import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blueAccent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 6.0,
      width: MediaQuery.of(context).size.width *
          0.8, // Set the width to 80% of the screen width
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.yellow,
        onPressed: () {
          // Handle action
        },
      ),
    ),
  );
}
