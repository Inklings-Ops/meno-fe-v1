import 'package:injectable/injectable.dart';

import '../../domain/entities/notification.dart';
import '../../domain/entities/notification_content.dart';
import '../../domain/entities/notification_data.dart';
import '../dtos/notification_content_dto.dart';
import '../dtos/notification_data_dto.dart';
import '../dtos/notification_dto.dart';

@singleton
class NotificationsMapper {
  Notification? notificationToDomain(NotificationDto? dto) {
    if (dto == null) return null;
    return Notification(
      content: contentToDomain(dto.content)!,
      createdAt: dto.createdAt,
      id: dto.id,
      read: dto.read,
      type: dto.type,
    );
  }

  NotificationDto? notificationToDto(Notification? entity) {
    if (entity == null) return null;
    return NotificationDto(
      content: contentToDto(entity.content)!,
      createdAt: entity.createdAt,
      id: entity.id,
      read: entity.read,
      type: entity.type,
    );
  }

  NotificationContent? contentToDomain(NotificationContentDto? dto) {
    if (dto == null) return null;
    return dto.map(
      userSubscribed: (e) => NotificationContent.userSubscribed(
        subscriberId: e.subscriberId,
        subscriberImageUrl: e.subscriberImageUrl,
        subscriberName: e.subscriberName,
        subscriptionId: e.subscriptionId,
      ),
      addedAsCoHost: (e) => NotificationContent.addedAsCoHost(
        broadcastCreator: e.broadcastCreator,
        broadcastId: e.broadcastId,
        broadcastImageUrl: e.broadcastImageUrl,
        broadcastTitle: e.broadcastTitle,
        cohostFullName: e.cohostFullName,
        cohostId: e.cohostId,
        cohostImageUrl: e.cohostImageUrl,
      ),
      liveBroadcastStarted: (e) => NotificationContent.liveBroadcastStarted(
        id: e.id,
        imageUrl: e.imageUrl,
        title: e.title,
      ),
    );
  }

  NotificationContentDto? contentToDto(NotificationContent? entity) {
    if (entity == null) return null;
    return entity.map(
      userSubscribed: (e) => NotificationContentDto.userSubscribed(
        subscriberId: e.subscriberId,
        subscriberImageUrl: e.subscriberImageUrl,
        subscriberName: e.subscriberName,
        subscriptionId: e.subscriptionId,
      ),
      addedAsCoHost: (e) => NotificationContentDto.addedAsCoHost(
        broadcastCreator: e.broadcastCreator,
        broadcastId: e.broadcastId,
        broadcastImageUrl: e.broadcastImageUrl,
        broadcastTitle: e.broadcastTitle,
        cohostFullName: e.cohostFullName,
        cohostId: e.cohostId,
        cohostImageUrl: e.cohostImageUrl,
      ),
      liveBroadcastStarted: (e) => NotificationContentDto.liveBroadcastStarted(
        id: e.id,
        imageUrl: e.imageUrl,
        title: e.title,
      ),
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
