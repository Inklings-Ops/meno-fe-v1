import 'package:equatable/equatable.dart';
import 'package:meno/shared/domain/entities/notification_settings.dart';

final class NotificationSettingDto with EquatableMixin {
  const NotificationSettingDto({
    required this.text,
    required this.type,
    required this.value,
  });

  factory NotificationSettingDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException(
        'Invalid JSON type for NotificationSettingDto: $json',
      );
    }

    return NotificationSettingDto(
      text: json[_kText] as String,
      type: json[_kType] as String,
      value: json[_kValue] as bool,
    );
  }

  static const _kText = 'text';
  static const _kType = 'type';
  static const _kValue = 'value';

  Map<String, dynamic> toJson() => {_kText: text, _kType: type, _kValue: value};

  final String text;
  final String type;
  final bool value;

  @override
  List<Object?> get props => [text, type, value];
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
