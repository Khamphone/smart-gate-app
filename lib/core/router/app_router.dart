import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/notifications/presentation/pages/notification_inbox_page.dart';
import '../../features/transactions/presentation/pages/transaction_detail_page.dart';
import '../di/injection.dart';
import '../../features/notifications/presentation/bloc/notification_bloc.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => BlocProvider.value(
          value: sl<NotificationBloc>(),
          child: const NotificationInboxPage(),
        ),
      ),
      GoRoute(
        path: '/transactions/:id',
        builder: (context, state) => TransactionDetailPage(
          transactionId: state.pathParameters['id']!,
        ),
      ),
    ],
  );
}
