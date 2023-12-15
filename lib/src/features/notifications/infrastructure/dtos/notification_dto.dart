import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notification_type.dart';
import 'notification_content_dto.dart';

part 'notification_dto.freezed.dart';
part 'notification_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class NotificationDto with _$NotificationDto {
  factory NotificationDto({
    required String id,
    required NotificationType type,
    required bool read,
    required NotificationContentDto content,
    required DateTime createdAt,
  }) = _NotificationDto;

  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationDtoToJson(this);
}
