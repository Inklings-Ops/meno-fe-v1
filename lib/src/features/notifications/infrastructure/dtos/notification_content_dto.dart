import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_content_dto.freezed.dart';
part 'notification_content_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class NotificationContentDto with _$NotificationContentDto {
  const factory NotificationContentDto({
    String? subscriberId,
    String? subscriberName,
    String? subscriptionId,
    String? subscriberImageUrl,
    String? cohostId,
    String? broadcastId,
    String? broadcastTitle,
    String? cohostFullName,
    String? cohostImageUrl,
    String? broadcastCreator,
    String? broadcastImageUrl,
    String? id,
    String? title,
    String? imageUrl,
  }) = _NotificationContentDto;

  factory NotificationContentDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationContentDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationContentDtoToJson(this);
}
