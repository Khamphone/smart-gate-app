import 'package:equatable/equatable.dart';

enum NotificationType {
  lowBalance,
  gateAlert,
  vehicleEntry,
  dailySummary,
  unknown,
}

class AppNotification extends Equatable {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime receivedAt;
  final bool isRead;
  final Map<String, String> payload;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.receivedAt,
    this.isRead = false,
    this.payload = const {},
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      type: type,
      receivedAt: receivedAt,
      isRead: isRead ?? this.isRead,
      payload: payload,
    );
  }

  @override
  List<Object?> get props => [id, title, body, type, receivedAt, isRead, payload];
}
