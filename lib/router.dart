import 'package:go_router/go_router.dart';
import 'package:money_app/screens/home.dart';
import 'package:money_app/screens/pay.dart';
import 'package:money_app/screens/top_up.dart';

final globalRouterConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/top-up',
      builder: (context, state) => const TopUpScreen(),
    ),
    GoRoute(
      path: '/pay',
      builder: (context, state) => const PayScreen(),
    ),
  ],
);
