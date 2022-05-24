import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

late FToast fToast = FToast();

showTosta(BuildContext context, IconData icon, Color color, String message) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: color,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        const SizedBox(
          width: 12.0,
        ),
        Text(message),
      ],
    ),
  );
  fToast.init(context);

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 3),
  );
}
