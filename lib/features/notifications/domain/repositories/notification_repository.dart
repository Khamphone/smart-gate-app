import '../entities/app_notification.dart';

abstract class NotificationRepository {
  /// Returns all stored notifications, newest first.
  Future<List<AppNotification>> getAll();

  /// Persists a notification received from FCM.
  Future<void> save(AppNotification notification);

  /// Marks a single notification as read.
  Future<void> markRead(String id);

  /// Marks every notification as read.
  Future<void> markAllRead();

  /// Deletes all notifications.
  Future<void> clearAll();

  /// Stream of unread count changes (for the badge).
  Stream<int> watchUnreadCount();
}
