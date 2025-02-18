part of 'settings_bloc.dart';

@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.changeLanguage() = ChangeLanguage;
  const factory SettingsEvent.toggleNotifications(
    bool value,
  ) = ToggleNotifications;
  const factory SettingsEvent.changeTheme(ThemeMode mode) = ChangeTheme;
  const factory SettingsEvent.toggleLocationServices(
    bool value,
   ) = ToggleLocationServices;
  const factory SettingsEvent.toggleLiveBroadcastsNotifications(
    bool value,
  ) =
      ToggleLiveBroadcastsNotifications;
  const factory SettingsEvent.toggleNewSubscribersNotifications(
    bool value,
  ) =
      ToggleNewSubscribersNotifications;
  const factory SettingsEvent.toggleAddedCohostNotifications(
    bool value,
  ) =
      ToggleAddedCohostNotifications;
}
