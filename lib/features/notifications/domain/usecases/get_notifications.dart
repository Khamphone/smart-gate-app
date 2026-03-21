import '../entities/app_notification.dart';
import '../repositories/notification_repository.dart';

class GetNotifications {
  final NotificationRepository _repository;
  const GetNotifications(this._repository);

  Future<List<AppNotification>> call() => _repository.getAll();
}
