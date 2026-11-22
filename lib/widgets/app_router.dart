import 'package:go_router/go_router.dart';

import 'welcome_page.dart';
import 'portfolio_page.dart';
import 'places_page.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'auth_check_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/auth-check',
  routes: [
    GoRoute(path: '/auth-check', builder: (context, state) => const AuthCheckPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
    GoRoute(path: '/', builder: (context, state) => const WelcomePage()),
    GoRoute(path: '/portfolio', builder: (context, state) => const PortfolioPage()),
    GoRoute(path: '/places', builder: (context, state) => const PlacesPage()),
  ],
);
