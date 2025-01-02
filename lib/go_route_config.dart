

import 'package:go_router/go_router.dart';
import 'package:literate_app/global_components/bottom_navigator.dart';
import 'package:literate_app/presentations/auth_screen/auth_screen.dart';
import 'package:literate_app/presentations/home_screen/home_screen.dart';
import 'package:literate_app/presentations/profile_screen/profile_screen.dart';
import 'package:literate_app/presentations/summarize_screen/summarize.dart';


final GoRouter goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    //  GoRoute(
    //   path: '/',
    //   builder: (context, state) => const InitialScreen(),
    // ),
    GoRoute(
      path: '/navigator',
      builder: (context, state) => const BottomNavigator(),
    ),
     GoRoute(
      path: '/',
      builder: (context, state) => const AuthScreen(),
    ),
     GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
     GoRoute(
      path: '/dictionary',
      builder: (context, state) => const SummarizeScreen(),
    ),
     GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
