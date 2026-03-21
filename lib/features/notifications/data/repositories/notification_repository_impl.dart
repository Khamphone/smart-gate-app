import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_datasource.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource _local;

  const NotificationRepositoryImpl({required NotificationLocalDataSource local})
      : _local = local;

  @override
  Future<List<AppNotification>> getAll() => _local.getAll();

  @override
  Future<void> save(AppNotification notification) {
    final model = NotificationModel(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      type: notification.type,
      receivedAt: notification.receivedAt,
      isRead: notification.isRead,
      payload: notification.payload,
    );
    return _local.save(model);
  }

  @override
  Future<void> markRead(String id) => _local.markRead(id);

  @override
  Future<void> markAllRead() => _local.markAllRead();

  @override
  Future<void> clearAll() => _local.clearAll();

  @override
  Stream<int> watchUnreadCount() => _local.watchUnreadCount();
}
