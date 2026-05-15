import 'package:fl_retrogame/screens/screens.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const initialRoute = 'home';

  static Map<String, Widget Function(BuildContext)> routes = {
    'home': (context) => HomeGame(),
    'insert': (context) => InsertScreenVideojuegos(),
    'update': (context) => UpdateScreenVideojuegos(uid: '', nombre: '', precio: '', estado: '', imagen: '',),
  };
}
  