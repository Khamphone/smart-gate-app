import '../repositories/notification_repository.dart';

class MarkNotificationRead {
  final NotificationRepository _repository;
  const MarkNotificationRead(this._repository);

  Future<void> call(String id) => _repository.markRead(id);
}

class MarkAllNotificationsRead {
  final NotificationRepository _repository;
  const MarkAllNotificationsRead(this._repository);

  Future<void> call() => _repository.markAllRead();
}
