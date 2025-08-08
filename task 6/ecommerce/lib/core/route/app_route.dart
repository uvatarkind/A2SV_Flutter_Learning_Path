import 'package:flutter/material.dart';
import 'package:ui_pages/feature/product/presentation/pages/addproduct.dart';
import 'package:ui_pages/feature/product/presentation/pages/details.dart';
import 'package:ui_pages/feature/product/presentation/pages/search.dart';

import '../../feature/product/presentation/pages/home.dart';
import '../../feature/auth/presentation/pages/log_in.dart';
import '../../feature/auth/presentation/pages/register.dart';
import '../../feature/auth/presentation/pages/splash_screen.dart';

class AppRoute {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // --- AUTH SCREENS ---
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case '/register':
        return MaterialPageRoute(builder: (_) => Register());

      case '/login':
        return MaterialPageRoute(builder: (_) => LogIn());

      case '/home':
        return MaterialPageRoute(builder: (_) => MyHomePage());

      case '/add':
        return MaterialPageRoute(builder: (_) => Addproduct());

      case '/search':
        return MaterialPageRoute(
          builder: (_) => SearchPage(
            buildCardList: (index) => [], ),);


      case '/details':
        return MaterialPageRoute(builder: (_) => DetialsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
