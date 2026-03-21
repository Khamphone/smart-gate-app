import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notification_bloc.dart';
import '../widgets/notification_tile.dart';

class NotificationInboxPage extends StatelessWidget {
  const NotificationInboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NotificationBloc, NotificationState>(
          buildWhen: (p, c) => p.unreadCount != c.unreadCount,
          builder: (context, state) => Text(
            state.unreadCount > 0
                ? 'Notifications (${state.unreadCount})'
                : 'Notifications',
          ),
        ),
        actions: [
          BlocBuilder<NotificationBloc, NotificationState>(
            buildWhen: (p, c) => p.unreadCount != c.unreadCount,
            builder: (context, state) {
              if (state.unreadCount == 0) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => context
                    .read<NotificationBloc>()
                    .add(const AllNotificationsRead()),
                child: const Text('Mark all read'),
              );
            },
          ),
          PopupMenuButton<_MenuAction>(
            onSelected: (action) {
              if (action == _MenuAction.clearAll) {
                context
                    .read<NotificationBloc>()
                    .add(const NotificationsCleared());
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: _MenuAction.clearAll,
                child: Text('Clear all'),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.notifications.isEmpty) {
            return const _EmptyInbox();
          }

          return RefreshIndicator(
            onRefresh: () async =>
                context.read<NotificationBloc>().add(const NotificationsLoaded()),
            child: ListView.separated(
              itemCount: state.notifications.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return Dismissible(
                  key: Key(notification.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    // For now, mark as read on dismiss.
                    // Replace with a delete use case if needed.
                    context
                        .read<NotificationBloc>()
                        .add(NotificationRead(notification.id));
                  },
                  child: NotificationTile(
                    notification: notification,
                    onTap: () => context
                        .read<NotificationBloc>()
                        .add(NotificationRead(notification.id)),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

enum _MenuAction { clearAll }

class _EmptyInbox extends StatelessWidget {
  const _EmptyInbox();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 12),
          Text(
            'No notifications yet',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
          ),
        ],
      ),
    );
  }
}
