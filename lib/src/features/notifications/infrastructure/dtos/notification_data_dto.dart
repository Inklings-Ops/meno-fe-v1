import 'package:freezed_annotation/freezed_annotation.dart';

import 'notification_dto.dart';

part 'notification_data_dto.freezed.dart';
part 'notification_data_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class NotificationDataDto with _$NotificationDataDto {

  factory NotificationDataDto({
    required List<NotificationDto?> notifications,
    required int totalPages,
    required int currentPage,
    required int totalItems,
  }) = _NotificationDataDto;

  factory NotificationDataDto.fromJson(Map<String, dynamic> json) => _$NotificationDataDtoFromJson(json);

@override
  Map<String, dynamic> toJson() => _$NotificationDataDtoToJson(this);
}