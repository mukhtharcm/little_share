import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_share/share/screens/manage_collection.dart';
import 'package:little_share/share/screens/shared_collection_list.dart';
import 'package:routemaster/routemaster.dart';
import 'package:little_share/auth/screens/login.dart';
import 'package:little_share/auth/screens/signup.dart';
import 'package:little_share/home/screens/home_view.dart';
import 'package:little_share/home/screens/profile_view.dart';

import '../share/screens/new_collection_screen.dart';

class Routes {
  final loggedInRoutes = RouteMap(
    onUnknownRoute: (_) => const Redirect('/'),
    routes: {
      "/": (_) => const MaterialPage(
            child: HomeView(),
          ),
      "/sharelist": (route) => const MaterialPage(
            child: SharedCollectionList(),
          ),
      "/newcollection": (route) => const MaterialPage(
            child: NewCollectionScreen(),
          ),
      "/managecollection/:id": (route) => MaterialPage(
            child: ManageCollectionView(
              collectionId: route.pathParameters['id'],
            ),
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
