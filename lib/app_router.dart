import 'package:flutter/material.dart';
import 'package:todo_app/presentation/home/home_screen.dart';
import 'package:todo_app/presentation/splash/splash_screen.dart';
import 'package:todo_app/shared/constants/router_const.dart';

class AppRouter {
  static AppRouter getInstance() => AppRouter();

  Route? generateRouter(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return getMaterialPageRoute(widget: const SplashScreen());
      case homeScreen:
        return getMaterialPageRoute(widget: HomeScreen());
    }
    return null;
  }

  dynamic getMaterialPageRoute({required Widget widget}) {
    return MaterialPageRoute(builder: (_) => widget);
  }
}
