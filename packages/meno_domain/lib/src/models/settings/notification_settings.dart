import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_settings.freezed.dart';

part 'notification_settings.g.dart';

/// Class for [NotificationSettings].
@freezed
abstract class NotificationSettings with _$NotificationSettings {
  /// Constructor for [NotificationSettings].
  const factory NotificationSettings({
    required String text,
    required String type,
    required bool value,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}
