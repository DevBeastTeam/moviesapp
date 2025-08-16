import 'package:flutter/material.dart';

import '../main.dart';

void showToast(String message) {
  ScaffoldMessenger.of(globalKey.currentState!.context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(
            globalKey.currentState!.context,
          ).hideCurrentSnackBar();
        },
      ),
    ),
  );
}
