part of 'settings_bloc.dart';

sealed class SettingsEvent with EquatableMixin {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

final class SettingsChangeLanguageRequested extends SettingsEvent {
  const SettingsChangeLanguageRequested();
}

final class SettingsToggleNotifications extends SettingsEvent {
  const SettingsToggleNotifications(this.value);
  final bool value;

  @override
  List<Object?> get props => [value];
}

final class SettingsChangeThemeRequested extends SettingsEvent {
  const SettingsChangeThemeRequested(this.mode);
  final ThemeMode mode;

  @override
  List<Object?> get props => [mode];
}

final class SettingsToggleLocationServices extends SettingsEvent {
  const SettingsToggleLocationServices(this.value);
  final bool value;

  @override
  List<Object?> get props => [value];
}

final class SettingsToggleLiveBroadcastsNotifications extends SettingsEvent {
  const SettingsToggleLiveBroadcastsNotifications(this.value);
  final bool value;

  @override
  List<Object?> get props => [value];
}

final class SettingsToggleNewSubscribersNotifications extends SettingsEvent {
  const SettingsToggleNewSubscribersNotifications(this.value);
  final bool value;

  @override
  List<Object?> get props => [value];
}

final class SettingsToggleAddedCohostNotifications extends SettingsEvent {
  const SettingsToggleAddedCohostNotifications(this.value);
  final bool value;

  @override
  List<Object?> get props => [value];
}
