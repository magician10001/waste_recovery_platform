// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'map.dart';
// ignore: unused_import
import 'consts.dart';

Route createRouteBottom() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => MapPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
