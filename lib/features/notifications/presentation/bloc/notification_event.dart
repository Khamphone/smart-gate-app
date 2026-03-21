part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class NotificationsLoaded extends NotificationEvent {
  const NotificationsLoaded();
}

class NotificationReceived extends NotificationEvent {
  final AppNotification notification;
  const NotificationReceived(this.notification);

  @override
  List<Object?> get props => [notification];
}

class NotificationRead extends NotificationEvent {
  final String id;
  const NotificationRead(this.id);

  @override
  List<Object?> get props => [id];
}

class AllNotificationsRead extends NotificationEvent {
  const AllNotificationsRead();
}

class NotificationsCleared extends NotificationEvent {
  const NotificationsCleared();
}

class _UnreadCountChanged extends NotificationEvent {
  final int count;
  const _UnreadCountChanged(this.count);

  @override
  List<Object?> get props => [count];
}
