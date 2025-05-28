import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meno_fe_v1/src/features/settings/domain/entities/entities.dart';

part 'notification_setting_dto.g.dart';

@JsonSerializable()
final class NotificationSettingDto with EquatableMixin {
  const NotificationSettingDto({
    required this.text,
    required this.type,
    required this.value,
  });

  factory NotificationSettingDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSettingDtoToJson(this);

  final String text;
  final String type;
  final bool value;

  @override
  List<Object?> get props => [text, type, value];

  @override
  bool get stringify => true;
}

extension NotificationSettingX on NotificationSettingDto {
  NotificationSetting get toDomain {
    return NotificationSetting(text: text, type: type, value: value);
  }
}

extension NotificationSettingDtoX on NotificationSetting {
  NotificationSettingDto get toDto {
    return NotificationSettingDto(text: text, type: type, value: value);
  }
}
