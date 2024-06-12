import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class ToastService {
  static Future<bool?> showErrorToast({required String message}) {
    return Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      backgroundColor: Colors.red[700],
      gravity: ToastGravity.TOP,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 3,
    );
  }

  static Future<bool?> showSuccessToast({required String message}) {
    return Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      backgroundColor: const Color(0xFF3B7CAD),
      gravity: ToastGravity.TOP,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 3,
    );
  }
}
