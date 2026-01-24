

import 'package:autumn/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      return MaterialPageRoute(builder: (_) => HomeScreen(title: "", color: Colors.black));


      default:
        return null;
    }
  }
}
