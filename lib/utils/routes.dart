import 'package:flutter/material.dart';

class Routes {
  static const home = '/';
  static const charge = '/charge';
  static const settings = '/settings';
}

Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}
