import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/buckets/buckets_screen.dart';
import '../presentation/screens/experiences/experiences_screen.dart';
import '../presentation/screens/journal/journal_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String buckets = '/buckets';
  static const String experiences = '/experiences';
  static const String journal = '/journal';
  static const String settings = '/settings';
}

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.buckets,
            name: 'buckets',
            builder: (context, state) => const BucketsScreen(),
          ),
          GoRoute(
            path: AppRoutes.experiences,
            name: 'experiences',
            builder: (context, state) => const ExperiencesScreen(),
          ),
          GoRoute(
            path: AppRoutes.journal,
            name: 'journal',
            builder: (context, state) => const JournalScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );

  static GoRouter get router => _router;
}

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;

    switch (currentLocation) {
      case AppRoutes.home:
        currentIndex = 0;
        break;
      case AppRoutes.buckets:
        currentIndex = 1;
        break;
      case AppRoutes.experiences:
        currentIndex = 2;
        break;
      case AppRoutes.journal:
        currentIndex = 3;
        break;
      case AppRoutes.settings:
        currentIndex = 4;
        break;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey.shade400,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          onTap: (index) => _onNavTap(context, index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list_outlined),
              activeIcon: Icon(Icons.view_list),
              label: 'Buckets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Experiences',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              activeIcon: Icon(Icons.book),
              label: 'Journal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  void _onNavTap(BuildContext context, int index) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    String targetRoute;

    switch (index) {
      case 0:
        targetRoute = AppRoutes.home;
        break;
      case 1:
        targetRoute = AppRoutes.buckets;
        break;
      case 2:
        targetRoute = AppRoutes.experiences;
        break;
      case 3:
        targetRoute = AppRoutes.journal;
        break;
      case 4:
        targetRoute = AppRoutes.settings;
        break;
      default:
        return;
    }

    if (currentLocation != targetRoute) {
      context.go(targetRoute);
    }
  }
}
