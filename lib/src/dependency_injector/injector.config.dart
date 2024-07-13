// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_messaging/firebase_messaging.dart' as _i10;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i11;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i12;
import 'package:get_it/get_it.dart' as _i1;
import 'package:image_picker/image_picker.dart' as _i13;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i14;
import 'package:shared_preferences/shared_preferences.dart' as _i28;

import '../features/auth/application/account/account_cubit.dart' as _i63;
import '../features/auth/application/application.dart' as _i81;
import '../features/auth/application/auth/auth_bloc.dart' as _i64;
import '../features/auth/application/login/login_cubit.dart' as _i46;
import '../features/auth/application/register/register_cubit.dart' as _i55;
import '../features/auth/application/reset_password/reset_password_cubit.dart'
    as _i56;
import '../features/auth/domain/domain.dart' as _i32;
import '../features/auth/infrastructure/auth_facade.dart' as _i33;
import '../features/auth/infrastructure/datasources/auth_local_datasource.dart'
    as _i30;
import '../features/auth/infrastructure/datasources/auth_remote_datasource.dart'
    as _i4;
import '../features/auth/infrastructure/mapper/auth_mapper.dart' as _i3;
import '../features/bible/application/bible/bible_bloc.dart' as _i65;
import '../features/bible/application/scripture_picker/scripture_picker_cubit.dart'
    as _i57;
import '../features/bible/application/translations/translations_cubit.dart'
    as _i61;
import '../features/bible/application/verses/verses_cubit.dart' as _i62;
import '../features/bible/domain/domain.dart' as _i34;
import '../features/bible/infrastructure/bible_facade.dart' as _i35;
import '../features/bible/infrastructure/datasources/datasources.dart' as _i36;
import '../features/bible/infrastructure/datasources/local/bible_local_datasource.dart'
    as _i31;
import '../features/bible/infrastructure/datasources/remote/bible_remote_datasource.dart'
    as _i5;
import '../features/broadcast/application/broadcast/broadcast_bloc.dart'
    as _i66;
import '../features/broadcast/application/broadcast_form/broadcast_form_cubit.dart'
    as _i67;
import '../features/broadcast/application/live_broadcasts/live_broadcasts_bloc.dart'
    as _i78;
import '../features/broadcast/application/live_participants/live_participants_bloc.dart'
    as _i79;
import '../features/broadcast/application/recently_live/recently_live_cubit.dart'
    as _i54;
import '../features/broadcast/application/stream/stream_bloc.dart' as _i60;
import '../features/broadcast/application/timer/timer_cubit.dart' as _i29;
import '../features/broadcast/domain/domain.dart' as _i37;
import '../features/broadcast/infrastructure/broadcast_facade.dart' as _i38;
import '../features/broadcast/infrastructure/datasources/broadcast_remote_datasource.dart'
    as _i8;
import '../features/broadcast/infrastructure/mapper/broadcast_list_mapper.dart'
    as _i6;
import '../features/broadcast/infrastructure/mapper/broadcast_mapper.dart'
    as _i7;
import '../features/chat/application/chat_bloc.dart' as _i68;
import '../features/discover/application/all/d_all_cubit.dart' as _i69;
import '../features/discover/application/filter/filter_bloc.dart' as _i72;
import '../features/discover/application/now_live/d_now_live_cubit.dart'
    as _i70;
import '../features/discover/application/recently_live/d_recently_live_cubit.dart'
    as _i71;
import '../features/discover/application/search/search_bloc.dart' as _i58;
import '../features/discover/discover.dart' as _i9;
import '../features/discover/infrastructure/discover_facade.dart' as _i39;
import '../features/network/application/network_cubit.dart' as _i48;
import '../features/network/domain/i_network_facade.dart' as _i40;
import '../features/network/infrastructure/network_facade.dart' as _i41;
import '../features/notes/application/folder_form/folder_form_cubit.dart'
    as _i87;
import '../features/notes/application/folder_list/folder_list_bloc.dart'
    as _i88;
import '../features/notes/application/note_form/note_form_cubit.dart' as _i84;
import '../features/notes/application/notes/notes_bloc.dart' as _i85;
import '../features/notes/domain/domain.dart' as _i73;
import '../features/notes/infrastructure/datasources/datasources.dart' as _i75;
import '../features/notes/infrastructure/datasources/note_local_datasource.dart'
    as _i49;
import '../features/notes/infrastructure/datasources/note_remote_datasource.dart'
    as _i20;
import '../features/notes/infrastructure/note_facade.dart' as _i74;
import '../features/notifications/domain/i_notification_facade.dart' as _i42;
import '../features/notifications/infrastructure/datasources/notification_remote_datasource.dart'
    as _i21;
import '../features/notifications/infrastructure/mapper/notifications_mapper.dart'
    as _i22;
import '../features/notifications/infrastructure/notification_facade.dart'
    as _i43;
import '../features/onboarding/application/onboarding_cubit.dart' as _i51;
import '../features/onboarding/domain/i_onboarding_facade.dart' as _i44;
import '../features/onboarding/infrastructure/onboarding_facade.dart' as _i45;
import '../features/onboarding/infrastructure/onboarding_local_datasource.dart'
    as _i52;
import '../features/onboarding/onboarding.dart' as _i47;
import '../features/profile/application/profile/my_profile_bloc.dart' as _i82;
import '../features/profile/application/profile_form/profile_form_cubit.dart'
    as _i86;
import '../features/profile/domain/domain.dart' as _i76;
import '../features/profile/infrastructure/datasources/profile_local_datasource.dart'
    as _i53;
import '../features/profile/infrastructure/datasources/profile_remote_datasource.dart'
    as _i26;
import '../features/profile/infrastructure/mapper/profile_mapper.dart' as _i25;
import '../features/profile/infrastructure/profile_facade.dart' as _i77;
import '../features/profile/profile.dart' as _i83;
import '../router/m_router.dart' as _i80;
import '../services/jwt_service.dart' as _i15;
import '../services/live_kit/live_kit_service.dart' as _i16;
import '../services/media_service.dart' as _i17;
import '../services/meno/meno_bloc.dart' as _i18;
import '../services/network_service.dart' as _i19;
import '../services/notification_service.dart' as _i50;
import '../services/objectbox_service.dart' as _i23;
import '../services/permissions_service.dart' as _i24;
import '../services/secure_storage_service.dart' as _i27;
import '../services/socket/socket_service.dart' as _i59;
import 'register_module.dart' as _i89;

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
    gh.singleton<_i3.AuthMapper>(_i3.AuthMapper());
    gh.lazySingleton<_i4.AuthRemoteDatasource>(
        () => registerModule.authRemoteDatasource);
    gh.lazySingleton<_i5.BibleRemoteDatasource>(
        () => registerModule.bibleRemoteDatasource);
    gh.singleton<_i6.BroadcastListMapper>(_i6.BroadcastListMapper());
    gh.singleton<_i7.BroadcastMapper>(_i7.BroadcastMapper());
    gh.lazySingleton<_i8.BroadcastRemoteDatasource>(
        () => registerModule.broadcastRemoteDatasource);
    gh.lazySingleton<_i9.DiscoverRemoteDatasource>(
        () => registerModule.discoverRemoteDatasource);
    gh.lazySingleton<_i10.FirebaseMessaging>(() => registerModule.fcm);
    gh.lazySingleton<_i11.FlutterLocalNotificationsPlugin>(
        () => registerModule.localNotifications);
    gh.lazySingleton<_i12.FlutterSecureStorage>(
        () => registerModule.secureStorage);
    gh.lazySingleton<_i13.ImagePicker>(() => registerModule.imagePicker);
    gh.lazySingleton<_i14.InternetConnectionChecker>(
        () => registerModule.internetChecker);
    gh.lazySingleton<_i15.JWTService>(() => _i15.JWTService());
    gh.lazySingleton<_i16.LiveKitService>(() => _i16.LiveKitService());
    gh.lazySingleton<_i17.MediaService>(
        () => _i17.MediaService(gh<_i13.ImagePicker>()));
    gh.lazySingleton<_i18.MenoBloc>(() => _i18.MenoBloc());
    gh.factory<_i19.NetworkService>(
        () => _i19.NetworkService(gh<_i14.InternetConnectionChecker>()));
    gh.lazySingleton<_i20.NoteRemoteDatasource>(
        () => registerModule.noteRemoteDatasource);
    gh.lazySingleton<_i21.NotificationRemoteDatasource>(
        () => registerModule.notificationRemoteDatasource);
    gh.singleton<_i22.NotificationsMapper>(_i22.NotificationsMapper());
    await gh.factoryAsync<_i23.ObjectBoxService>(
      () => registerModule.obj,
      preResolve: true,
    );
    await gh.factoryAsync<_i24.PermissionsService>(
      () {
        final i = _i24.PermissionsService();
        return i.checkPermissions().then((_) => i);
      },
      preResolve: true,
    );
    gh.singleton<_i25.ProfileMapper>(_i25.ProfileMapper());
    gh.lazySingleton<_i26.ProfileRemoteDatasource>(
        () => registerModule.profileRemoteDatasource);
    gh.lazySingleton<_i27.SecureStorageService>(
        () => _i27.SecureStorageService());
    await gh.factoryAsync<_i28.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i29.TimerCubit>(() => _i29.TimerCubit());
    gh.factory<_i30.AuthLocalDatasource>(() =>
        _i30.AuthLocalDatasource(storage: gh<_i27.SecureStorageService>()));
    gh.factory<_i31.BibleLocalDatasource>(() =>
        _i31.BibleLocalDatasource(objectBox: gh<_i23.ObjectBoxService>()));
    await gh.factoryAsync<_i32.IAuthFacade>(
      () {
        final i = _i33.AuthFacade(
          authMapper: gh<_i3.AuthMapper>(),
          remoteDatasource: gh<_i4.AuthRemoteDatasource>(),
          localDatasource: gh<_i30.AuthLocalDatasource>(),
          networkService: gh<_i19.NetworkService>(),
          jwtService: gh<_i15.JWTService>(),
        );
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    await gh.factoryAsync<_i34.IBibleFacade>(
      () {
        final i = _i35.BibleFacade(
          local: gh<_i36.BibleLocalDatasource>(),
          remote: gh<_i36.BibleRemoteDatasource>(),
          network: gh<_i19.NetworkService>(),
        );
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.factory<_i37.IBroadcastFacade>(() => _i38.BroadcastFacade(
          mapper: gh<_i7.BroadcastMapper>(),
          listMapper: gh<_i6.BroadcastListMapper>(),
          remote: gh<_i8.BroadcastRemoteDatasource>(),
          network: gh<_i19.NetworkService>(),
        ));
    gh.factory<_i9.IDiscoverFacade>(() => _i39.DiscoverFacade(
          remote: gh<_i9.DiscoverRemoteDatasource>(),
          network: gh<_i19.NetworkService>(),
        ));
    gh.lazySingleton<_i40.INetworkFacade>(() =>
        _i41.NetworkFacade(connectivity: gh<_i14.InternetConnectionChecker>()));
    gh.lazySingleton<_i42.INotificationFacade>(() => _i43.NotificationFacade(
          remoteDatasource: gh<_i21.NotificationRemoteDatasource>(),
          networkService: gh<_i19.NetworkService>(),
        ));
    gh.factory<_i44.IOnboardingFacade>(
        () => _i45.OnboardingFacade(storage: gh<_i28.SharedPreferences>()));
    gh.lazySingleton<_i46.LoginCubit>(() => _i46.LoginCubit(
          facade: gh<_i32.IAuthFacade>(),
          onboardingFacade: gh<_i47.IOnboardingFacade>(),
        ));
    gh.lazySingleton<_i48.NetworkCubit>(
        () => _i48.NetworkCubit(facade: gh<_i40.INetworkFacade>()));
    gh.factory<_i49.NoteLocalDatasource>(
        () => _i49.NoteLocalDatasource(pref: gh<_i28.SharedPreferences>()));
    await gh.factoryAsync<_i50.NotificationService>(
      () {
        final i = _i50.NotificationService(
          firebaseMessaging: gh<_i10.FirebaseMessaging>(),
          storageService: gh<_i27.SecureStorageService>(),
        );
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i51.OnboardingCubit>(
        () => _i51.OnboardingCubit(facade: gh<_i44.IOnboardingFacade>()));
    gh.factory<_i52.OnboardingLocalDatasource>(() =>
        _i52.OnboardingLocalDatasource(storage: gh<_i28.SharedPreferences>()));
    gh.factory<_i53.ProfileLocalDatasource>(() =>
        _i53.ProfileLocalDatasource(storage: gh<_i27.SecureStorageService>()));
    gh.lazySingleton<_i54.RecentlyLiveCubit>(
        () => _i54.RecentlyLiveCubit(facade: gh<_i37.IBroadcastFacade>()));
    gh.lazySingleton<_i55.RegisterCubit>(
        () => _i55.RegisterCubit(facade: gh<_i32.IAuthFacade>()));
    gh.lazySingleton<_i56.ResetPasswordCubit>(
        () => _i56.ResetPasswordCubit(facade: gh<_i32.IAuthFacade>()));
    gh.factory<_i57.ScripturePickerCubit>(
        () => _i57.ScripturePickerCubit(facade: gh<_i34.IBibleFacade>()));
    gh.lazySingleton<_i58.SearchBloc>(
        () => _i58.SearchBloc(facade: gh<_i9.IDiscoverFacade>()));
    await gh.factoryAsync<_i59.SocketService>(
      () {
        final i = _i59.SocketService(facade: gh<_i32.IAuthFacade>());
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i60.StreamBloc>(() => _i60.StreamBloc(
          facade: gh<_i37.IBroadcastFacade>(),
          liveKit: gh<_i16.LiveKitService>(),
          socket: gh<_i59.SocketService>(),
          menoBloc: gh<_i18.MenoBloc>(),
          timer: gh<_i29.TimerCubit>(),
        ));
    gh.factory<_i61.TranslationsCubit>(
        () => _i61.TranslationsCubit(facade: gh<_i34.IBibleFacade>()));
    gh.factory<_i62.VersesCubit>(
        () => _i62.VersesCubit(facade: gh<_i34.IBibleFacade>()));
    gh.factory<_i63.AccountCubit>(
        () => _i63.AccountCubit(facade: gh<_i32.IAuthFacade>()));
    gh.lazySingleton<_i64.AuthBloc>(() => _i64.AuthBloc(
          facade: gh<_i32.IAuthFacade>(),
          onboardingFacade: gh<_i47.IOnboardingFacade>(),
        ));
    gh.factory<_i65.BibleBloc>(
        () => _i65.BibleBloc(facade: gh<_i34.IBibleFacade>()));
    gh.lazySingleton<_i66.BroadcastBloc>(() => _i66.BroadcastBloc(
          facade: gh<_i37.IBroadcastFacade>(),
          liveKit: gh<_i16.LiveKitService>(),
          socket: gh<_i59.SocketService>(),
          menoBloc: gh<_i18.MenoBloc>(),
          timer: gh<_i29.TimerCubit>(),
        ));
    gh.lazySingleton<_i67.BroadcastFormCubit>(() => _i67.BroadcastFormCubit(
          facade: gh<_i37.IBroadcastFacade>(),
          mediaService: gh<_i17.MediaService>(),
        ));
    gh.lazySingleton<_i68.ChatBloc>(() => _i68.ChatBloc(
          facade: gh<_i32.IAuthFacade>(),
          socket: gh<_i59.SocketService>(),
        )..init());
    gh.lazySingleton<_i69.DAllCubit>(
        () => _i69.DAllCubit(facade: gh<_i9.IDiscoverFacade>()));
    gh.lazySingleton<_i70.DNowLiveCubit>(
        () => _i70.DNowLiveCubit(facade: gh<_i9.IDiscoverFacade>()));
    gh.lazySingleton<_i71.DRecentlyLiveCubit>(
        () => _i71.DRecentlyLiveCubit(facade: gh<_i9.IDiscoverFacade>()));
    gh.lazySingleton<_i72.FilterBloc>(
        () => _i72.FilterBloc(facade: gh<_i9.IDiscoverFacade>()));
    gh.factory<_i73.INoteFacade>(() => _i74.NoteFacade(
          network: gh<_i19.NetworkService>(),
          local: gh<_i75.NoteLocalDatasource>(),
          remote: gh<_i75.NoteRemoteDatasource>(),
        ));
    gh.lazySingleton<_i76.IProfileFacade>(() => _i77.ProfileFacade(
          remote: gh<_i26.ProfileRemoteDatasource>(),
          local: gh<_i53.ProfileLocalDatasource>(),
          network: gh<_i19.NetworkService>(),
        ));
    gh.lazySingleton<_i78.LiveBroadcastsBloc>(
        () => _i78.LiveBroadcastsBloc(socket: gh<_i59.SocketService>()));
    gh.lazySingleton<_i79.LiveParticipantsBloc>(
        () => _i79.LiveParticipantsBloc(socket: gh<_i59.SocketService>()));
    gh.factory<_i80.MRouter>(() => _i80.MRouter(
          authBloc: gh<_i81.AuthBloc>(),
          onboardingCubit: gh<_i51.OnboardingCubit>(),
        ));
    gh.lazySingleton<_i82.MyProfileBloc>(
        () => _i82.MyProfileBloc(facade: gh<_i83.IProfileFacade>()));
    gh.factoryParam<_i84.NoteFormCubit, _i73.Note?, dynamic>((
      initialNote,
      _,
    ) =>
        _i84.NoteFormCubit(
          facade: gh<_i73.INoteFacade>(),
          initialNote: initialNote,
        ));
    gh.lazySingleton<_i85.NotesBloc>(
        () => _i85.NotesBloc(facade: gh<_i73.INoteFacade>()));
    gh.lazySingleton<_i86.ProfileFormCubit>(() => _i86.ProfileFormCubit(
          facade: gh<_i76.IProfileFacade>(),
          media: gh<_i17.MediaService>(),
        ));
    gh.lazySingleton<_i87.FolderFormCubit>(
        () => _i87.FolderFormCubit(facade: gh<_i73.INoteFacade>()));
    gh.lazySingleton<_i88.FolderListBloc>(
        () => _i88.FolderListBloc(facade: gh<_i73.INoteFacade>()));
    return this;
  }
}

class _$RegisterModule extends _i89.RegisterModule {}
