import 'package:meno_fe_v1/meno.dart';

part 'settings_event.dart';
part 'settings_state.dart';
part 'settings_bloc.freezed.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<ChangeLanguage>(_onChangeLanguage);
    on<ToggleNotifications>(_onToggleNotifications);
    on<ChangeTheme>(_onChangeTheme);
    on<ToggleLocationServices>(_onToggleLocationServices);
    on<ToggleLiveBroadcastsNotifications>(_onToggleLiveBroadcastsNotifications);
    on<ToggleNewSubscribersNotifications>(_onToggleNewSubscribersNotifications);
    on<ToggleAddedCohostNotifications>(_onToggleAddedCohostNotifications);
  }

  void _onChangeLanguage(ChangeLanguage event, Emitter<SettingsState> emit) {}

  void _onToggleNotifications(
    ToggleNotifications event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(receiveNotifications: event.value));
  }

  void _onChangeTheme(ChangeTheme event, Emitter<SettingsState> emit) {
    emit(state.copyWith(themeMode: event.mode));
  }

  void _onToggleLocationServices(
    ToggleLocationServices event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(useLocation: event.value));
  }

  void _onToggleLiveBroadcastsNotifications(
    ToggleLiveBroadcastsNotifications event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(receiveLiveBroadcastsNotifications: event.value));
  }

  void _onToggleNewSubscribersNotifications(
    ToggleNewSubscribersNotifications event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(receiveNewSubscribersNotifications: event.value));
  }

  void _onToggleAddedCohostNotifications(
    ToggleAddedCohostNotifications event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(receiveAddedCohostNotifications: event.value));
  }
}
