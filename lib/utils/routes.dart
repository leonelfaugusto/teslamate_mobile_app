import 'package:flutter/material.dart';

class Routes {
  static const home = '/';
  static const charge = '/charge';
  static const drive = '/drive';
  static const settings = '/settings';
  static const followMap = '/follow_map';
}

Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}
