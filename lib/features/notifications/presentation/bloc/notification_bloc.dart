import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/fcm_service.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notification_read.dart';
import '../../data/models/notification_model.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotifications _getNotifications;
  final MarkNotificationRead _markRead;
  final MarkAllNotificationsRead _markAllRead;
  final NotificationRepository _repository;

  late final StreamSubscription<RemoteMessage> _fcmSub;
  late final StreamSubscription<int> _unreadSub;

  NotificationBloc({
    required GetNotifications getNotifications,
    required MarkNotificationRead markRead,
    required MarkAllNotificationsRead markAllRead,
    required NotificationRepository repository,
  })  : _getNotifications = getNotifications,
        _markRead = markRead,
        _markAllRead = markAllRead,
        _repository = repository,
        super(const NotificationState()) {
    on<NotificationsLoaded>(_onLoaded);
    on<NotificationReceived>(_onReceived);
    on<NotificationRead>(_onRead);
    on<AllNotificationsRead>(_onAllRead);
    on<NotificationsCleared>(_onCleared);
    on<_UnreadCountChanged>(_onUnreadChanged);

    // Listen to FCM foreground stream and badge count updates.
    _fcmSub = FcmService.instance.onMessage.listen((message) {
      final model = NotificationModel.fromFcm(
        id: message.messageId ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: message.notification?.title ??
            message.data['title'] ??
            'Smart Gate',
        body: message.notification?.body ?? message.data['body'] ?? '',
        data: message.data.map((k, v) => MapEntry(k, v.toString())),
      );
      add(NotificationReceived(model));
    });

    _unreadSub = _repository
        .watchUnreadCount()
        .listen((count) => add(_UnreadCountChanged(count)));
  }

  Future<void> _onLoaded(
      NotificationsLoaded event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(isLoading: true));
    final notifications = await _getNotifications();
    final unread = notifications.where((n) => !n.isRead).length;
    emit(state.copyWith(
        notifications: notifications, unreadCount: unread, isLoading: false));
  }

  Future<void> _onReceived(
      NotificationReceived event, Emitter<NotificationState> emit) async {
    await _repository.save(event.notification);
    final notifications = await _getNotifications();
    final unread = notifications.where((n) => !n.isRead).length;
    emit(state.copyWith(notifications: notifications, unreadCount: unread));
  }

  Future<void> _onRead(
      NotificationRead event, Emitter<NotificationState> emit) async {
    await _markRead(event.id);
    final updated =
        state.notifications.map((n) => n.id == event.id ? n.copyWith(isRead: true) : n).toList();
    emit(state.copyWith(
        notifications: updated,
        unreadCount: updated.where((n) => !n.isRead).length));
  }

  Future<void> _onAllRead(
      AllNotificationsRead event, Emitter<NotificationState> emit) async {
    await _markAllRead();
    final updated = state.notifications.map((n) => n.copyWith(isRead: true)).toList();
    emit(state.copyWith(notifications: updated, unreadCount: 0));
  }

  Future<void> _onCleared(
      NotificationsCleared event, Emitter<NotificationState> emit) async {
    await _repository.clearAll();
    emit(state.copyWith(notifications: [], unreadCount: 0));
  }

  void _onUnreadChanged(
      _UnreadCountChanged event, Emitter<NotificationState> emit) {
    emit(state.copyWith(unreadCount: event.count));
  }

  @override
  Future<void> close() {
    _fcmSub.cancel();
    _unreadSub.cancel();
    return super.close();
  }
}
