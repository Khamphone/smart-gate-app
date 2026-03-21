import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification_model.dart';

abstract class NotificationLocalDataSource {
  Future<List<NotificationModel>> getAll();
  Future<void> save(NotificationModel notification);
  Future<void> markRead(String id);
  Future<void> markAllRead();
  Future<void> clearAll();
  Stream<int> watchUnreadCount();
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  static const _key = 'smart_gate_notifications';

  final SharedPreferences _prefs;
  final _unreadController = StreamController<int>.broadcast();

  NotificationLocalDataSourceImpl(this._prefs);

  @override
  Future<List<NotificationModel>> getAll() async {
    final raw = _prefs.getStringList(_key) ?? [];
    return raw
        .map((s) => NotificationModel.fromJson(
            jsonDecode(s) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
  }

  @override
  Future<void> save(NotificationModel notification) async {
    final all = await getAll();
    // Keep max 100 notifications
    final updated = [notification, ...all].take(100).toList();
    await _persist(updated);
    _emitUnread(updated);
  }

  @override
  Future<void> markRead(String id) async {
    final all = await getAll();
    final updated = all
        .map((n) => n.id == id ? n.copyWithRead() : n)
        .toList();
    await _persist(updated);
    _emitUnread(updated);
  }

  @override
  Future<void> markAllRead() async {
    final all = await getAll();
    final updated = all.map((n) => n.copyWithRead()).toList();
    await _persist(updated);
    _unreadController.add(0);
  }

  @override
  Future<void> clearAll() async {
    await _prefs.remove(_key);
    _unreadController.add(0);
  }

  @override
  Stream<int> watchUnreadCount() => _unreadController.stream;

  Future<void> _persist(List<NotificationModel> items) async {
    await _prefs.setStringList(
      _key,
      items.map((n) => n.toJsonString()).toList(),
    );
  }

  void _emitUnread(List<NotificationModel> items) {
    _unreadController.add(items.where((n) => !n.isRead).length);
  }
}
