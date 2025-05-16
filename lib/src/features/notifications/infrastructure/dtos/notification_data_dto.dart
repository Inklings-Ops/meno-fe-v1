import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/notifications/notifications.dart';

part 'notification_data_dto.freezed.dart';
part 'notification_data_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class NotificationDataDto with _$NotificationDataDto {
  const factory NotificationDataDto({
    required List<NotificationDto?> notifications,
    required int totalPages,
    required int currentPage,
    required int totalItems,
  }) = _NotificationDataDto;

  factory NotificationDataDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationDataDtoToJson(this);
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
