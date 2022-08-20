import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:little_share/auth/screens/login.dart';
import 'package:little_share/auth/screens/signup.dart';
import 'package:little_share/home/screens/home_view.dart';
import 'package:little_share/home/screens/profile_view.dart';

class Routes {
  final loggedInRoutes = RouteMap(
    onUnknownRoute: (_) => const Redirect('/'),
    routes: {
      "/": (_) => const MaterialPage(
            child: HomeView(),
          ),
      "/profile": (_) => const MaterialPage(
            child: ProfileView(),
          ),
      "/login": (_) => const MaterialPage(
            child: LoginView(),
          ),
      "/signup": (route) => const MaterialPage(
            child: SignUpView(),
          )
    },
  );

  final loggedOutRoutes = RouteMap(
      onUnknownRoute: (_) => const MaterialPage(child: LoginView()),
      routes: {
        "/login": (_) => const MaterialPage(
              child: LoginView(),
            ),
        "/signup": (route) => const MaterialPage(
              child: SignUpView(),
            )
      });
}

final routesProvider = Provider<Routes>((ref) => Routes());
