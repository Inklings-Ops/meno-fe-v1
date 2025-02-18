part of 'settings_bloc.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(ThemeMode.dark) ThemeMode themeMode,
    @Default('English') String language,
    @Default(false) bool useLocation,
    @Default(false) bool receiveNotifications,
    @Default(false) bool receiveLiveBroadcastsNotifications,
    @Default(false) bool receiveNewSubscribersNotifications,
    @Default(false) bool receiveAddedCohostNotifications,
  }) = _SettingsState;
}
