import 'package:injectable/injectable.dart';

import 'package:meno_fe_v1/src/features/notifications/domain/entities/notification.dart';
import 'package:meno_fe_v1/src/features/notifications/domain/entities/notification_content.dart';
import 'package:meno_fe_v1/src/features/notifications/domain/entities/notification_data.dart';
import 'package:meno_fe_v1/src/features/notifications/infrastructure/dtos/notification_content_dto.dart';
import 'package:meno_fe_v1/src/features/notifications/infrastructure/dtos/notification_data_dto.dart';
import 'package:meno_fe_v1/src/features/notifications/infrastructure/dtos/notification_dto.dart';

@singleton
class NotificationsMapper {
  Notification? notificationToDomain(NotificationDto? dto) {
    if (dto == null) return null;
    return Notification(
      content: NotificationContent(
        subscriberId: dto.content.subscriberId,
        subscriberImageUrl: dto.content.subscriberImageUrl,
        subscriberName: dto.content.subscriberName,
        subscriptionId: dto.content.subscriptionId,
        broadcastCreator: dto.content.broadcastCreator,
        broadcastId: dto.content.broadcastId,
        broadcastImageUrl: dto.content.broadcastImageUrl,
        broadcastTitle: dto.content.broadcastTitle,
        cohostFullName: dto.content.cohostFullName,
        cohostId: dto.content.cohostId,
        cohostImageUrl: dto.content.cohostImageUrl,
        id: dto.content.id,
        imageUrl: dto.content.imageUrl,
        title: dto.content.title,
      ),
      createdAt: dto.createdAt,
      id: dto.id,
      read: dto.read,
      type: dto.type,
    );
  }

  NotificationDto? notificationToDto(Notification? entity) {
    if (entity == null) return null;
    return NotificationDto(
      content: NotificationContentDto(
        subscriberId: entity.content.subscriberId,
        subscriberImageUrl: entity.content.subscriberImageUrl,
        subscriberName: entity.content.subscriberName,
        subscriptionId: entity.content.subscriptionId,
        broadcastCreator: entity.content.broadcastCreator,
        broadcastId: entity.content.broadcastId,
        broadcastImageUrl: entity.content.broadcastImageUrl,
        broadcastTitle: entity.content.broadcastTitle,
        cohostFullName: entity.content.cohostFullName,
        cohostId: entity.content.cohostId,
        cohostImageUrl: entity.content.cohostImageUrl,
        id: entity.content.id,
        imageUrl: entity.content.imageUrl,
        title: entity.content.title,
      ),
      createdAt: entity.createdAt,
      id: entity.id,
      read: entity.read,
      type: entity.type,
    );
  }

  NotificationData? dataToDomain(NotificationDataDto? dto) {
    if (dto == null) return null;
    return NotificationData(
      currentPage: dto.currentPage,
      notifications: dto.notifications.map(notificationToDomain).toList(),
      totalItems: dto.totalItems,
      totalPages: dto.totalPages,
    );
  }

  NotificationDataDto? dataToDto(NotificationData? domain) {
    if (domain == null) return null;
    return NotificationDataDto(
      currentPage: domain.currentPage,
      notifications: domain.notifications.map(notificationToDto).toList(),
      totalItems: domain.totalItems,
      totalPages: domain.totalPages,
    );
  }
}
