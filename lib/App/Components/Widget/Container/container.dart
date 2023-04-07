// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

Widget containerDefault(BuildContext context, Widget body) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: Colors.white),
    child: body,
  );
}
