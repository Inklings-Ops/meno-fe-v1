import 'package:meno/features/notifications/models/entities/notification_type.dart';

class NotificationPayload {
  const NotificationPayload({
    required this.type,
    this.userId,
    this.broadcastId,
  });

  /// Parse directly from the FCM data map.
  factory NotificationPayload.fromData(Map<String, dynamic> data) {
    return NotificationPayload(
      type: .fromString(data['type'] as String?) ?? .userSubscribed,
      userId: data['userId'] as String?,
      broadcastId: data['broadcastId'] as String?,
    );
  }

  final NotificationType type;
  final String? userId; // present for userSubscribed, addedAsCoHost
  final String? broadcastId;

  /// Encode to a string so flutter_local_notifications can carry it
  /// as a payload through the system tray tap.
  String encode() {
    final buffer = StringBuffer(type.name);
    if (userId != null) buffer.write('|userId=$userId');
    if (broadcastId != null) buffer.write('|broadcastId=$broadcastId');
    return buffer.toString();
  }

  /// Decode from the string stored in the notification payload field.
  static NotificationPayload? decode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final parts = raw.split('|');
    final type = NotificationType.fromString(parts.first);
    if (type == null) return null;

    String? userId;
    String? broadcastId;

    for (final part in parts.skip(1)) {
      if (part.startsWith('userId=')) userId = part.substring(7);
      if (part.startsWith('broadcastId=')) broadcastId = part.substring(12);
    }

    return NotificationPayload(
      type: type,
      userId: userId,
      broadcastId: broadcastId,
    );
  }
}
