import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/notification_bloc.dart';

/// App bar action button with an unread-count badge.
class NotificationBadge extends StatelessWidget {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      buildWhen: (prev, curr) => prev.unreadCount != curr.unreadCount,
      builder: (context, state) {
        return IconButton(
          tooltip: 'Notifications',
          onPressed: () => context.push('/notifications'),
          icon: Badge(
            isLabelVisible: state.unreadCount > 0,
            label: Text(
              state.unreadCount > 99 ? '99+' : state.unreadCount.toString(),
            ),
            child: const Icon(Icons.notifications_outlined),
          ),
        );
      },
    );
  }
}
