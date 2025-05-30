import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meno_fe_v1/src/features/notifications/notifications.dart';

part 'notification_data_dto.g.dart';

@JsonSerializable()
class NotificationDataDto with EquatableMixin {
  const NotificationDataDto({
    required this.notifications,
    required this.totalPages,
    required this.currentPage,
    required this.totalItems,
  });

  factory NotificationDataDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataDtoFromJson(json);

  final List<NotificationDto?> notifications;
  final int totalPages;
  final int currentPage;
  final int totalItems;

  Map<String, dynamic> toJson() => _$NotificationDataDtoToJson(this);

  @override
  List<Object?> get props => [
        notifications,
        totalPages,
        currentPage,
        totalItems,
      ];
}

extension NotificationDataToDomainX on NotificationDataDto {
  NotificationData get toDomain {
    return NotificationData(
      notifications: notifications.map((b) => b?.toDomain).toList(),
      totalPages: totalPages,
      currentPage: currentPage,
      totalItems: totalItems,
    );
  }
}

extension NotificationDataToDtoX on NotificationData {
  NotificationDataDto get toDto {
    return NotificationDataDto(
      notifications: notifications.map((b) => b?.toDto).toList(),
      totalPages: totalPages,
      currentPage: currentPage,
      totalItems: totalItems,
    );
  }
}
