// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';

alertError(BuildContext context, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      dismissDirection: DismissDirection.startToEnd,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      behavior: SnackBarBehavior.floating,
      content: ListTile(
        leading: Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: Colors.red),
          child: Icon(
            Icons.warning_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
          message,
          style: TextStyle(
              color: Colors.white, fontFamily: 'poppins', fontSize: 16),
        ),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red,
    ),
  );
}
