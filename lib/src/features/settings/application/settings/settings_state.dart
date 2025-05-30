part of 'settings_bloc.dart';

final class SettingsState with EquatableMixin {
  const SettingsState({
    this.themeMode = ThemeMode.dark,
    this.language = 'English',
    this.useLocation = false,
    this.receiveNotifications = false,
    this.receiveLiveBroadcastsNotifications = false,
    this.receiveNewSubscribersNotifications = false,
    this.receiveAddedCohostNotifications = false,
  });

  final ThemeMode themeMode;
  final String language;
  final bool useLocation;
  final bool receiveNotifications;
  final bool receiveLiveBroadcastsNotifications;
  final bool receiveNewSubscribersNotifications;
  final bool receiveAddedCohostNotifications;

  @override
  List<Object?> get props => [
        themeMode,
        language,
        useLocation,
        receiveNotifications,
        receiveLiveBroadcastsNotifications,
        receiveNewSubscribersNotifications,
        receiveAddedCohostNotifications,
      ];

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? language,
    bool? useLocation,
    bool? receiveNotifications,
    bool? receiveLiveBroadcastsNotifications,
    bool? receiveNewSubscribersNotifications,
    bool? receiveAddedCohostNotifications,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      useLocation: useLocation ?? this.useLocation,
      receiveNotifications: receiveNotifications ?? this.receiveNotifications,
      receiveLiveBroadcastsNotifications: receiveLiveBroadcastsNotifications ??
          this.receiveLiveBroadcastsNotifications,
      receiveNewSubscribersNotifications: receiveNewSubscribersNotifications ??
          this.receiveNewSubscribersNotifications,
      receiveAddedCohostNotifications: receiveAddedCohostNotifications ??
          this.receiveAddedCohostNotifications,
    );
  }
}
