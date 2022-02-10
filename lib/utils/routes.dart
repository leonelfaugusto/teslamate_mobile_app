import 'package:flutter/material.dart';

class Routes {
  static const home = '/';
  static const charge = '/charge';
  static const settings = '/settings';
}

class RoutesTabNames {
  static const dashboard = 'Dashboard';
  static const charge = 'Carregamentos';
  static const drive = 'Percursos';
  static const statistics = 'Estatísticas';
  static const settings = 'Definições';
}

Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}
