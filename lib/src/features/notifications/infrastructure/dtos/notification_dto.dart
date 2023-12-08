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
    @_ContentConverter() required NotificationContentDto content,
    required DateTime createdAt,
  }) = _NotificationDto;

  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationDtoToJson(this);
}

class _ContentConverter
    implements JsonConverter<NotificationContentDto, Map<String, dynamic>> {
  const _ContentConverter();

  @override
  NotificationContentDto fromJson(Map<String, dynamic> json) {
    // type data was already set (e.g. because we serialized it ourselves)
    if (json['runtimeType'] != null) {
      return NotificationContentDto.fromJson(json);
    }

    final type = json["type"] as NotificationType;

    // you need to find some condition to know which type it is. e.g. check the presence of some field in the json
    switch (type) {
      case NotificationType.addedAsCoHost:
        return AddedAsCoHost.fromJson(json);
      case NotificationType.userSubscribed:
        return UserSubscribed.fromJson(json);
      case NotificationType.liveBroadcastStarted:
        return LiveBroadcastStarted.fromJson(json);
      default:
        throw Exception(
          'Could not determine the constructor for mapping from JSON',
        );
    }
  }

  @override
  Map<String, dynamic> toJson(NotificationContentDto data) => data.toJson();
}
