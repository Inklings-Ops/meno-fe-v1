import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/meno.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<SettingsChangeLanguageRequested>(_onSettingsChangeLanguageRequested);
    on<SettingsToggleNotifications>(_onSettingsToggleNotifications);
    on<SettingsChangeThemeRequested>(_onSettingsChangeThemeRequested);
    on<SettingsToggleLocationServices>(_onSettingsToggleLocationServices);
    on<SettingsToggleLiveBroadcastsNotifications>(
      _onSettingsToggleLiveBroadcastsNotifications,
    );
    on<SettingsToggleNewSubscribersNotifications>(
      _onSettingsToggleNewSubscribersNotifications,
    );
    on<SettingsToggleAddedCohostNotifications>(
      _onSettingsToggleAddedCohostNotifications,
    );
  }

  void _onSettingsChangeLanguageRequested(
    SettingsChangeLanguageRequested event,
    Emitter<SettingsState> emit,
  ) {}

  void _onSettingsToggleNotifications(
    SettingsToggleNotifications event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(receiveNotifications: event.value));
  }

  void _onSettingsChangeThemeRequested(
    SettingsChangeThemeRequested event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(themeMode: event.mode));
  }

  void _onSettingsToggleLocationServices(
    SettingsToggleLocationServices event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(useLocation: event.value));
  }

  void _onSettingsToggleLiveBroadcastsNotifications(
    SettingsToggleLiveBroadcastsNotifications event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(receiveLiveBroadcastsNotifications: event.value));
  }

  void _onSettingsToggleNewSubscribersNotifications(
    SettingsToggleNewSubscribersNotifications event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(receiveNewSubscribersNotifications: event.value));
  }

  void _onSettingsToggleAddedCohostNotifications(
    SettingsToggleAddedCohostNotifications event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(receiveAddedCohostNotifications: event.value));
  }
}
