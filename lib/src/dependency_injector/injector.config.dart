// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_messaging/firebase_messaging.dart' as _i7;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i8;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i9;
import 'package:get_it/get_it.dart' as _i1;
import 'package:image_picker/image_picker.dart' as _i10;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i11;
import 'package:shared_preferences/shared_preferences.dart' as _i25;

import '../../config.dart' as _i15;
import '../core/network/application/network_cubit.dart' as _i42;
import '../core/network/domain/i_network_facade.dart' as _i38;
import '../core/network/infrastructure/network_facade.dart' as _i39;
import '../features/auth/application/account/account_bloc.dart' as _i58;
import '../features/auth/application/login/login_cubit.dart' as _i74;
import '../features/auth/application/register/register_cubit.dart' as _i48;
import '../features/auth/application/reset_password/reset_password_cubit.dart'
    as _i49;
import '../features/auth/auth.dart' as _i29;
import '../features/auth/domain/domain.dart' as _i50;
import '../features/auth/infrastructure/auth_facade.dart' as _i30;
import '../features/auth/infrastructure/datasources/auth_local_datasource.dart'
    as _i27;
import '../features/auth/infrastructure/datasources/auth_remote_datasource.dart'
    as _i3;
import '../features/bible/application/bible/bible_bloc.dart' as _i59;
import '../features/bible/application/scripture_picker/scripture_picker_cubit.dart'
    as _i51;
import '../features/bible/application/translations/translations_cubit.dart'
    as _i56;
import '../features/bible/application/verses/verses_cubit.dart' as _i57;
import '../features/bible/domain/domain.dart' as _i32;
import '../features/bible/infrastructure/bible_facade.dart' as _i33;
import '../features/bible/infrastructure/datasources/datasources.dart' as _i34;
import '../features/bible/infrastructure/datasources/local/bible_local_datasource.dart'
    as _i28;
import '../features/bible/infrastructure/datasources/remote/bible_remote_datasource.dart'
    as _i4;
import '../features/broadcast/application/broadcast/broadcast_bloc.dart'
    as _i60;
import '../features/broadcast/application/broadcast_form/broadcast_form_cubit.dart'
    as _i61;
import '../features/broadcast/application/live_broadcasts/live_broadcasts_bloc.dart'
    as _i72;
import '../features/broadcast/application/live_participants/live_participants_bloc.dart'
    as _i73;
import '../features/broadcast/application/recently_live/recently_live_cubit.dart'
    as _i46;
import '../features/broadcast/application/stream/stream_bloc.dart' as _i55;
import '../features/broadcast/application/timer/timer_cubit.dart' as _i26;
import '../features/broadcast/broadcast.dart' as _i35;
import '../features/broadcast/domain/domain.dart' as _i47;
import '../features/broadcast/infrastructure/broadcast_facade.dart' as _i36;
import '../features/broadcast/infrastructure/datasources/broadcast_remote_datasource.dart'
    as _i5;
import '../features/chat/application/chat_bloc.dart' as _i90;
import '../features/discover/application/all/d_all_cubit.dart' as _i62;
import '../features/discover/application/filter/filter_bloc.dart' as _i65;
import '../features/discover/application/now_live/d_now_live_cubit.dart'
    as _i63;
import '../features/discover/application/recently_live/d_recently_live_cubit.dart'
    as _i64;
import '../features/discover/application/search/search_bloc.dart' as _i52;
import '../features/discover/discover.dart' as _i6;
import '../features/discover/infrastructure/discover_facade.dart' as _i37;
import '../features/notes/application/folder/folder_cubit.dart' as _i83;
import '../features/notes/application/folder_form/folder_form_cubit.dart'
    as _i84;
import '../features/notes/application/folder_list/folder_list_bloc.dart'
    as _i85;
import '../features/notes/application/note_form/note_form_cubit.dart' as _i78;
import '../features/notes/application/notes/notes_bloc.dart' as _i80;
import '../features/notes/domain/domain.dart' as _i79;
import '../features/notes/infrastructure/datasources/note_local_datasource.dart'
    as _i43;
import '../features/notes/infrastructure/datasources/note_remote_datasource.dart'
    as _i17;
import '../features/notes/infrastructure/note_facade.dart' as _i67;
import '../features/notes/notes.dart' as _i66;
import '../features/notifications/domain/i_notification_facade.dart' as _i40;
import '../features/notifications/infrastructure/datasources/notification_remote_datasource.dart'
    as _i18;
import '../features/notifications/infrastructure/mapper/notifications_mapper.dart'
    as _i19;
import '../features/notifications/infrastructure/notification_facade.dart'
    as _i41;
import '../features/profile/application/profile/my_profile_bloc.dart' as _i76;
import '../features/profile/application/profile_form/profile_form_cubit.dart'
    as _i82;
import '../features/profile/domain/domain.dart' as _i68;
import '../features/profile/infrastructure/datasources/profile_local_datasource.dart'
    as _i45;
import '../features/profile/infrastructure/datasources/profile_remote_datasource.dart'
    as _i23;
import '../features/profile/infrastructure/mapper/profile_mapper.dart' as _i22;
import '../features/profile/infrastructure/profile_facade.dart' as _i69;
import '../features/profile/profile.dart' as _i77;
import '../features/settings/application/onboarding/onboarding_cubit.dart'
    as _i81;
import '../features/settings/infrastructure/datasources/settings_local_datasource.dart'
    as _i53;
import '../features/settings/infrastructure/settings_facade.dart' as _i71;
import '../features/settings/settings.dart' as _i70;
import '../services/jwt_service.dart' as _i12;
import '../services/live_kit/live_kit_service.dart' as _i13;
import '../services/media_service.dart' as _i14;
import '../services/meno/meno_bloc.dart' as _i75;
import '../services/network_service.dart' as _i16;
import '../services/notification_service.dart' as _i44;
import '../services/objectbox_service.dart' as _i20;
import '../services/permissions_service.dart' as _i21;
import '../services/secure_storage_service.dart' as _i24;
import '../services/services.dart' as _i31;
import '../services/socket/socket_service.dart' as _i54;
import '../shared/session/cubit/session_cubit.dart' as _i88;
import '../shared/session/session.dart' as _i86;
import '../shared/session/session_context.dart' as _i87;
import '../shared/shared.dart' as _i89;
import 'register_module.dart' as _i91;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i3.AuthRemoteDatasource>(
        () => registerModule.authRemoteDatasource);
    gh.lazySingleton<_i4.BibleRemoteDatasource>(
        () => registerModule.bibleRemoteDatasource);
    gh.lazySingleton<_i5.BroadcastRemoteDatasource>(
        () => registerModule.broadcastRemoteDatasource);
    gh.lazySingleton<_i6.DiscoverRemoteDatasource>(
        () => registerModule.discoverRemoteDatasource);
    gh.lazySingleton<_i7.FirebaseMessaging>(() => registerModule.fcm);
    gh.lazySingleton<_i8.FlutterLocalNotificationsPlugin>(
        () => registerModule.localNotifications);
    gh.lazySingleton<_i9.FlutterSecureStorage>(
        () => registerModule.secureStorage);
    gh.lazySingleton<_i10.ImagePicker>(() => registerModule.imagePicker);
    gh.lazySingleton<_i11.InternetConnectionChecker>(
        () => registerModule.internetChecker);
    gh.lazySingleton<_i12.JWTService>(() => _i12.JWTService());
    gh.lazySingleton<_i13.LiveKitService>(() => _i13.LiveKitService());
    gh.lazySingleton<_i14.MediaService>(
        () => _i14.MediaService(gh<_i10.ImagePicker>()));
    gh.factory<_i15.MenoConfig>(() => _i15.MenoConfig());
    gh.factory<_i16.NetworkService>(
        () => _i16.NetworkService(gh<_i11.InternetConnectionChecker>()));
    gh.lazySingleton<_i17.NoteRemoteDatasource>(
        () => registerModule.noteRemoteDatasource);
    gh.lazySingleton<_i18.NotificationRemoteDatasource>(
        () => registerModule.notificationRemoteDatasource);
    gh.singleton<_i19.NotificationsMapper>(_i19.NotificationsMapper());
    await gh.factoryAsync<_i20.ObjectBoxService>(
      () => registerModule.obj,
      preResolve: true,
    );
    await gh.factoryAsync<_i21.PermissionsService>(
      () {
        final i = _i21.PermissionsService();
        return i.checkPermissions().then((_) => i);
      },
      preResolve: true,
    );
    gh.singleton<_i22.ProfileMapper>(_i22.ProfileMapper());
    gh.lazySingleton<_i23.ProfileRemoteDatasource>(
        () => registerModule.profileRemoteDatasource);
    gh.lazySingleton<_i24.SecureStorageService>(
        () => _i24.SecureStorageService());
    await gh.factoryAsync<_i25.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i26.TimerCubit>(() => _i26.TimerCubit());
    gh.factory<_i27.AuthLocalDatasource>(() =>
        _i27.AuthLocalDatasource(storage: gh<_i24.SecureStorageService>()));
    gh.factory<_i28.BibleLocalDatasource>(() =>
        _i28.BibleLocalDatasource(objectBox: gh<_i20.ObjectBoxService>()));
    await gh.factoryAsync<_i29.IAuthFacade>(
      () {
        final i = _i30.AuthFacade(
          remoteDatasource: gh<_i29.AuthRemoteDatasource>(),
          localDatasource: gh<_i29.AuthLocalDatasource>(),
          networkService: gh<_i31.NetworkService>(),
          jwtService: gh<_i31.JWTService>(),
        );
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    await gh.factoryAsync<_i32.IBibleFacade>(
      () {
        final i = _i33.BibleFacade(
          local: gh<_i34.BibleLocalDatasource>(),
          remote: gh<_i34.BibleRemoteDatasource>(),
          network: gh<_i16.NetworkService>(),
        );
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.factory<_i35.IBroadcastFacade>(() => _i36.BroadcastFacade(
          remote: gh<_i35.BroadcastRemoteDatasource>(),
          network: gh<_i31.NetworkService>(),
        ));
    gh.factory<_i6.IDiscoverFacade>(() => _i37.DiscoverFacade(
          remote: gh<_i6.DiscoverRemoteDatasource>(),
          network: gh<_i16.NetworkService>(),
        ));
    gh.lazySingleton<_i38.INetworkFacade>(() =>
        _i39.NetworkFacade(connectivity: gh<_i11.InternetConnectionChecker>()));
    gh.lazySingleton<_i40.INotificationFacade>(() => _i41.NotificationFacade(
          remoteDatasource: gh<_i18.NotificationRemoteDatasource>(),
          networkService: gh<_i16.NetworkService>(),
        ));
    gh.lazySingleton<_i42.NetworkCubit>(
        () => _i42.NetworkCubit(facade: gh<_i38.INetworkFacade>()));
    gh.factory<_i43.NoteLocalDatasource>(
        () => _i43.NoteLocalDatasource(pref: gh<_i25.SharedPreferences>()));
    await gh.factoryAsync<_i44.NotificationService>(
      () {
        final i = _i44.NotificationService(
          firebaseMessaging: gh<_i7.FirebaseMessaging>(),
          storageService: gh<_i24.SecureStorageService>(),
        );
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.factory<_i45.ProfileLocalDatasource>(() =>
        _i45.ProfileLocalDatasource(storage: gh<_i24.SecureStorageService>()));
    gh.lazySingleton<_i46.RecentlyLiveCubit>(
        () => _i46.RecentlyLiveCubit(facade: gh<_i47.IBroadcastFacade>()));
    gh.lazySingleton<_i48.RegisterCubit>(
        () => _i48.RegisterCubit(facade: gh<_i29.IAuthFacade>()));
    gh.lazySingleton<_i49.ResetPasswordCubit>(
        () => _i49.ResetPasswordCubit(facade: gh<_i50.IAuthFacade>()));
    gh.factory<_i51.ScripturePickerCubit>(
        () => _i51.ScripturePickerCubit(facade: gh<_i32.IBibleFacade>()));
    gh.lazySingleton<_i52.SearchBloc>(
        () => _i52.SearchBloc(facade: gh<_i6.IDiscoverFacade>()));
    gh.factory<_i53.SettingsLocalDatasource>(() => _i53.SettingsLocalDatasource(
        preferences: gh<_i25.SharedPreferences>()));
    await gh.factoryAsync<_i54.SocketService>(
      () {
        final i = _i54.SocketService(facade: gh<_i50.IAuthFacade>());
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.factory<_i55.StreamBloc>(() => _i55.StreamBloc(
          facade: gh<_i35.IBroadcastFacade>(),
          liveKit: gh<_i31.LiveKitService>(),
          socket: gh<_i31.SocketService>(),
        ));
    gh.factory<_i56.TranslationsCubit>(
        () => _i56.TranslationsCubit(facade: gh<_i32.IBibleFacade>()));
    gh.factory<_i57.VersesCubit>(
        () => _i57.VersesCubit(facade: gh<_i32.IBibleFacade>()));
    gh.lazySingleton<_i58.AccountBloc>(
        () => _i58.AccountBloc(facade: gh<_i29.IAuthFacade>()));
    gh.factory<_i59.BibleBloc>(
        () => _i59.BibleBloc(facade: gh<_i32.IBibleFacade>()));
    gh.factory<_i60.BroadcastBloc>(() => _i60.BroadcastBloc(
          facade: gh<_i35.IBroadcastFacade>(),
          liveKit: gh<_i31.LiveKitService>(),
          socket: gh<_i31.SocketService>(),
        ));
    gh.lazySingleton<_i61.BroadcastFormCubit>(() => _i61.BroadcastFormCubit(
          facade: gh<_i35.IBroadcastFacade>(),
          mediaService: gh<_i14.MediaService>(),
        ));
    gh.lazySingleton<_i62.DAllCubit>(
        () => _i62.DAllCubit(facade: gh<_i6.IDiscoverFacade>()));
    gh.lazySingleton<_i63.DNowLiveCubit>(
        () => _i63.DNowLiveCubit(facade: gh<_i6.IDiscoverFacade>()));
    gh.lazySingleton<_i64.DRecentlyLiveCubit>(
        () => _i64.DRecentlyLiveCubit(facade: gh<_i6.IDiscoverFacade>()));
    gh.lazySingleton<_i65.FilterBloc>(
        () => _i65.FilterBloc(facade: gh<_i6.IDiscoverFacade>()));
    gh.factory<_i66.INoteFacade>(() => _i67.NoteFacade(
          network: gh<_i31.NetworkService>(),
          local: gh<_i66.NoteLocalDatasource>(),
          remote: gh<_i66.NoteRemoteDatasource>(),
        ));
    gh.lazySingleton<_i68.IProfileFacade>(() => _i69.ProfileFacade(
          remote: gh<_i23.ProfileRemoteDatasource>(),
          local: gh<_i45.ProfileLocalDatasource>(),
          network: gh<_i16.NetworkService>(),
        ));
    gh.factory<_i70.ISettingsFacade>(
        () => _i71.SettingsFacade(local: gh<_i70.SettingsLocalDatasource>()));
    gh.lazySingleton<_i72.LiveBroadcastsBloc>(() => _i72.LiveBroadcastsBloc(
          facade: gh<_i35.IBroadcastFacade>(),
          socket: gh<_i31.SocketService>(),
        ));
    gh.lazySingleton<_i73.LiveParticipantsBloc>(
        () => _i73.LiveParticipantsBloc(socket: gh<_i31.SocketService>()));
    gh.lazySingleton<_i74.LoginCubit>(() => _i74.LoginCubit(
          facade: gh<_i29.IAuthFacade>(),
          settingsFacade: gh<_i70.ISettingsFacade>(),
        ));
    gh.factory<_i75.MenoBloc>(() => _i75.MenoBloc(
          liveKit: gh<_i31.LiveKitService>(),
          socket: gh<_i31.SocketService>(),
        ));
    gh.lazySingleton<_i76.MyProfileBloc>(
        () => _i76.MyProfileBloc(facade: gh<_i77.IProfileFacade>()));
    gh.factoryParam<_i78.NoteFormCubit, _i79.Note?, dynamic>((
      initialNote,
      _,
    ) =>
        _i78.NoteFormCubit(
          facade: gh<_i79.INoteFacade>(),
          initialNote: initialNote,
        ));
    gh.lazySingleton<_i80.NotesBloc>(
        () => _i80.NotesBloc(facade: gh<_i66.INoteFacade>()));
    gh.lazySingleton<_i81.OnboardingCubit>(
        () => _i81.OnboardingCubit(facade: gh<_i70.ISettingsFacade>()));
    gh.lazySingleton<_i82.ProfileFormCubit>(() => _i82.ProfileFormCubit(
          facade: gh<_i68.IProfileFacade>(),
          media: gh<_i14.MediaService>(),
        ));
    gh.factoryParam<_i83.FolderCubit, _i79.Folder, dynamic>((
      folder,
      _,
    ) =>
        _i83.FolderCubit(
          facade: gh<_i79.INoteFacade>(),
          folder: folder,
        ));
    gh.lazySingleton<_i84.FolderFormCubit>(
        () => _i84.FolderFormCubit(facade: gh<_i79.INoteFacade>()));
    gh.lazySingleton<_i85.FolderListBloc>(
        () => _i85.FolderListBloc(facade: gh<_i66.INoteFacade>()));
    gh.factory<_i86.ISessionContext>(() => _i87.SessionContext(
          authFacade: gh<_i29.IAuthFacade>(),
          settingsFacade: gh<_i70.ISettingsFacade>(),
        )..init());
    await gh.factoryAsync<_i88.SessionCubit>(
      () {
        final i = _i88.SessionCubit(session: gh<_i89.ISessionContext>());
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i90.ChatBloc>(() => _i90.ChatBloc(
          session: gh<_i89.ISessionContext>(),
          socket: gh<_i31.SocketService>(),
          profileFacade: gh<_i77.IProfileFacade>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i91.RegisterModule {}
