import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      //margin: const EdgeInsets.only(bottom: 100.0),
      content: Text(text),
    ),
  );
}
