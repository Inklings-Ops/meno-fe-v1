import 'package:meno/_shared/_shared.dart';

class UserSettingsPatch {
  UserSettingsPatch({
    UserDisplay? display,
    String? language,
    bool? appNotifications,
    bool? pushNotifications,
    bool? emailNotifications,
    UserNotificationSettingsPatch? notificationSettings,
  }) : _display = _Patch.fromNullable(display),
       _language = _Patch.fromNullable(language),
       _appNotifications = _Patch.fromNullable(appNotifications),
       _pushNotifications = _Patch.fromNullable(pushNotifications),
       _emailNotifications = _Patch.fromNullable(emailNotifications),
       _notificationSettings = _Patch.fromNullable(notificationSettings);

  final _Patch<UserDisplay> _display;
  final _Patch<String> _language;
  final _Patch<bool> _appNotifications;
  final _Patch<bool> _pushNotifications;
  final _Patch<bool> _emailNotifications;
  final _Patch<UserNotificationSettingsPatch> _notificationSettings;

  static const _kDisplay = 'display';
  static const _kLanguage = 'language';
  static const _kAppNotifications = 'appNotifications';
  static const _kPushNotifications = 'pushNotifications';
  static const _kEmailNotifications = 'emailNotifications';
  static const _kNotificationSettings = 'notificationSettings';

  /// Returns a Map containing ONLY the fields explicitly provided to the
  /// constructor. Fields left as null are omitted entirely.
  Map<String, dynamic> toJson() {
    return {
      if (_display.isSet) _kDisplay: _display.value.value,
      if (_language.isSet) _kLanguage: _language.value,
      if (_appNotifications.isSet) _kAppNotifications: _appNotifications.value,
      if (_pushNotifications.isSet)
        _kPushNotifications: _pushNotifications.value,
      if (_emailNotifications.isSet)
        _kEmailNotifications: _emailNotifications.value,
      // Only include the sub-object key when the patch itself is non-empty,
      // avoiding sending {"notificationSettings": {}} to the API.
      if (_notificationSettings.isSet &&
          _notificationSettings.value.toJson().isNotEmpty)
        _kNotificationSettings: _notificationSettings.value.toJson(),
    };
  }

  bool get isEmpty => toJson().isEmpty;
}

// ---------------------------------------------------------------------------
// UserNotificationSettingsPatch  — same sentinel pattern for the sub-object
// ---------------------------------------------------------------------------

class UserNotificationSettingsPatch {
  UserNotificationSettingsPatch({
    bool? userSubscribed,
    bool? addedAsCoHost,
    bool? liveBroadcastStarted,
    bool? scheduledBroadcast,
  }) : _userSubscribed = _Patch.fromNullable(userSubscribed),
       _addedAsCoHost = _Patch.fromNullable(addedAsCoHost),
       _liveBroadcastStarted = _Patch.fromNullable(liveBroadcastStarted),
       _scheduledBroadcast = _Patch.fromNullable(scheduledBroadcast);

  final _Patch<bool> _userSubscribed;
  final _Patch<bool> _addedAsCoHost;
  final _Patch<bool> _liveBroadcastStarted;
  final _Patch<bool> _scheduledBroadcast;

  static const _kUserSubscribed = 'userSubscribed';
  static const _kAddedAsCoHost = 'addedAsCoHost';
  static const _kLiveBroadcastStarted = 'liveBroadcastStarted';
  static const _kScheduledBroadcast = 'scheduledBroadcast';

  Map<String, dynamic> toJson() {
    return {
      if (_userSubscribed.isSet) _kUserSubscribed: _userSubscribed.value,
      if (_addedAsCoHost.isSet) _kAddedAsCoHost: _addedAsCoHost.value,
      if (_liveBroadcastStarted.isSet)
        _kLiveBroadcastStarted: _liveBroadcastStarted.value,
      if (_scheduledBroadcast.isSet)
        _kScheduledBroadcast: _scheduledBroadcast.value,
    };
  }
}

class _Patch<T> {
  const _Patch._(this._value, this.isSet);

  /// Creates a set patch from a non-null value.
  factory _Patch.fromNullable(T? value) {
    if (value == null) return _Patch._(null as T, false);
    return _Patch._(value, true);
  }

  final T _value;
  final bool isSet;

  T get value {
    assert(isSet, '_Patch.value accessed on an absent patch');
    return _value;
  }
}
