import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/notifications/presentation/pages/notification_inbox_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/transactions/presentation/pages/transaction_detail_page.dart';
import '../di/injection.dart';
import '../../features/notifications/presentation/bloc/notification_bloc.dart';
import 'main_shell.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // ── Auth (no shell) ───────────────────────────────────────────────────
      GoRoute(path: '/splash', builder: (_, __) => const SplashPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      GoRoute(
          path: '/forgot-password',
          builder: (_, __) => const ForgotPasswordPage()),
      GoRoute(
        path: '/otp',
        builder: (_, state) => OtpPage(
          email: state.uri.queryParameters['email'] ?? '',
        ),
      ),

      // ── Transaction detail (pushed on top of shell) ───────────────────────
      GoRoute(
        path: '/transactions/:id',
        builder: (_, state) => TransactionDetailPage(
          transactionId: state.pathParameters['id']!,
        ),
      ),

      // ── Main app shell (bottom nav) ───────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          // Home / Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (_, __) => const DashboardPage(),
              ),
            ],
          ),
          // Notifications
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/notifications',
                builder: (context, _) => BlocProvider.value(
                  value: sl<NotificationBloc>(),
                  child: const NotificationInboxPage(),
                ),
              ),
            ],
          ),
          // Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (_, __) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
