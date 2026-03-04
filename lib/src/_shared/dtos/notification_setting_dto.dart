import 'package:meno/src/_exceptions/exceptions.dart';
import 'package:meno/src/_shared/models/models.dart';

final class NotificationSettingDto {
  const NotificationSettingDto({
    required this.text,
    required this.type,
    required this.value,
  });

  factory NotificationSettingDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatError<NotificationSettingDto>();
    }

    return NotificationSettingDto(
      text: json['text'] as String,
      type: json['type'] as String,
      value: json['value'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {'text': text, 'type': type, 'value': value};

  final String text;
  final String type;
  final bool value;
}

extension NotificationSettingDtoX on NotificationSettingDto {
  NotificationSetting get toDomain {
    return NotificationSetting(text: text, type: type, value: value);
  }
}

extension NotificationSettingX on NotificationSetting {
  NotificationSettingDto get toDto {
    return NotificationSettingDto(text: text, type: type, value: value);
  }
}
