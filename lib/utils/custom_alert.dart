import 'package:flutter/material.dart';

Future<void> customalert(
    {required BuildContext context, required String message}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 40,
        ),
        title: Text(message),
      );
    },
  );
}
