import 'dart:convert';

import '../../domain/entities/app_notification.dart';

class NotificationModel extends AppNotification {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.type,
    required super.receivedAt,
    super.isRead,
    super.payload,
  });

  factory NotificationModel.fromFcm({
    required String id,
    required String title,
    required String body,
    required Map<String, String> data,
  }) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      type: _parseType(data['type']),
      receivedAt: DateTime.now(),
      payload: data,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationType.values.byName(json['type'] as String),
      receivedAt: DateTime.parse(json['receivedAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
      payload: Map<String, String>.from(json['payload'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'type': type.name,
        'receivedAt': receivedAt.toIso8601String(),
        'isRead': isRead,
        'payload': payload,
      };

  String toJsonString() => jsonEncode(toJson());

  static NotificationType _parseType(String? raw) {
    return switch (raw) {
      'low_balance' => NotificationType.lowBalance,
      'gate_alert' => NotificationType.gateAlert,
      'vehicle_entry' => NotificationType.vehicleEntry,
      'daily_summary' => NotificationType.dailySummary,
      _ => NotificationType.unknown,
    };
  }

  NotificationModel copyWithRead() => NotificationModel(
        id: id,
        title: title,
        body: body,
        type: type,
        receivedAt: receivedAt,
        isRead: true,
        payload: payload,
      );
}
