import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_domain/src/converters/converters.dart';
import 'package:meno_domain/src/models/settings/notification_settings.dart';
import 'package:meno_domain/src/value_objects/id.dart';

part 'settings.freezed.dart';

part 'settings.g.dart';

/// General Settings for the app.
@freezed
abstract class Settings with _$Settings {
  /// Constructor for the Settings class.
  const factory Settings({
    @IdConverter() required Id id,
    @IdConverter() required Id userId,
    required List<NotificationSettings> notificationSettings,
    @Default(false) bool pushNotifications,
    @Default(true) bool appNotifications,
    @Default(false) bool emailNotifications,
    @Default('light') String display,
    @Default('en/English') String language,
    String? pushNotificationToken,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
}
