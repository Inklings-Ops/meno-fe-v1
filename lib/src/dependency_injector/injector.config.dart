// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_messaging/firebase_messaging.dart' as _i9;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i10;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i11;
import 'package:get_it/get_it.dart' as _i1;
import 'package:image_picker/image_picker.dart' as _i12;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i13;
import 'package:shared_preferences/shared_preferences.dart' as _i27;

import '../features/auth/application/account/account_bloc.dart' as _i67;
import '../features/auth/application/login/login_cubit.dart' as _i49;
import '../features/auth/application/register/register_cubit.dart' as _i58;
import '../features/auth/application/reset_password/reset_password_cubit.dart'
    as _i59;
import '../features/auth/auth.dart' as _i31;
import '../features/auth/domain/domain.dart' as _i50;
import '../features/auth/infrastructure/auth_facade.dart' as _i32;
import '../features/auth/infrastructure/datasources/auth_local_datasource.dart'
    as _i29;
import '../features/auth/infrastructure/datasources/auth_remote_datasource.dart'
    as _i3;
import '../features/bible/application/bible/bible_bloc.dart' as _i68;
import '../features/bible/application/scripture_picker/scripture_picker_cubit.dart'
    as _i60;
import '../features/bible/application/translations/translations_cubit.dart'
    as _i65;
import '../features/bible/application/verses/verses_cubit.dart' as _i66;
import '../features/bible/domain/domain.dart' as _i34;
import '../features/bible/infrastructure/bible_facade.dart' as _i35;
import '../features/bible/infrastructure/datasources/datasources.dart' as _i36;
import '../features/bible/infrastructure/datasources/local/bible_local_datasource.dart'
    as _i30;
import '../features/bible/infrastructure/datasources/remote/bible_remote_datasource.dart'
    as _i4;
import '../features/broadcast/application/broadcast/broadcast_bloc.dart'
    as _i69;
import '../features/broadcast/application/broadcast_form/broadcast_form_cubit.dart'
    as _i70;
import '../features/broadcast/application/live_broadcasts/live_broadcasts_bloc.dart'
    as _i81;
import '../features/broadcast/application/live_participants/live_participants_bloc.dart'
    as _i82;
import '../features/broadcast/application/recently_live/recently_live_cubit.dart'
    as _i57;
import '../features/broadcast/application/stream/stream_bloc.dart' as _i64;
import '../features/broadcast/application/timer/timer_cubit.dart' as _i28;
import '../features/broadcast/domain/domain.dart' as _i37;
import '../features/broadcast/infrastructure/broadcast_facade.dart' as _i38;
import '../features/broadcast/infrastructure/datasources/broadcast_remote_datasource.dart'
    as _i7;
import '../features/broadcast/infrastructure/mapper/broadcast_list_mapper.dart'
    as _i5;
import '../features/broadcast/infrastructure/mapper/broadcast_mapper.dart'
    as _i6;
import '../features/chat/application/chat_bloc.dart' as _i71;
import '../features/discover/application/all/d_all_cubit.dart' as _i72;
import '../features/discover/application/filter/filter_bloc.dart' as _i75;
import '../features/discover/application/now_live/d_now_live_cubit.dart'
    as _i73;
import '../features/discover/application/recently_live/d_recently_live_cubit.dart'
    as _i74;
import '../features/discover/application/search/search_bloc.dart' as _i61;
import '../features/discover/discover.dart' as _i8;
import '../features/discover/infrastructure/discover_facade.dart' as _i39;
import '../features/network/application/network_cubit.dart' as _i51;
import '../features/network/domain/i_network_facade.dart' as _i40;
import '../features/network/infrastructure/network_facade.dart' as _i41;
import '../features/notes/application/folder_form/folder_form_cubit.dart'
    as _i88;
import '../features/notes/application/folder_list/folder_list_bloc.dart'
    as _i89;
import '../features/notes/application/note_form/note_form_cubit.dart' as _i85;
import '../features/notes/application/notes/notes_bloc.dart' as _i86;
import '../features/notes/domain/domain.dart' as _i76;
import '../features/notes/infrastructure/datasources/datasources.dart' as _i78;
import '../features/notes/infrastructure/datasources/note_local_datasource.dart'
    as _i52;
import '../features/notes/infrastructure/datasources/note_remote_datasource.dart'
    as _i19;
import '../features/notes/infrastructure/note_facade.dart' as _i77;
import '../features/notifications/domain/i_notification_facade.dart' as _i42;
import '../features/notifications/infrastructure/datasources/notification_remote_datasource.dart'
    as _i20;
import '../features/notifications/infrastructure/mapper/notifications_mapper.dart'
    as _i21;
import '../features/notifications/infrastructure/notification_facade.dart'
    as _i43;
import '../features/onboarding/application/onboarding_cubit.dart' as _i54;
import '../features/onboarding/domain/i_onboarding_facade.dart' as _i44;
import '../features/onboarding/infrastructure/onboarding_facade.dart' as _i45;
import '../features/onboarding/infrastructure/onboarding_local_datasource.dart'
    as _i55;
import '../features/onboarding/onboarding.dart' as _i48;
import '../features/profile/application/profile/my_profile_bloc.dart' as _i83;
import '../features/profile/application/profile_form/profile_form_cubit.dart'
    as _i87;
import '../features/profile/domain/domain.dart' as _i79;
import '../features/profile/infrastructure/datasources/profile_local_datasource.dart'
    as _i56;
import '../features/profile/infrastructure/datasources/profile_remote_datasource.dart'
    as _i25;
import '../features/profile/infrastructure/mapper/profile_mapper.dart' as _i24;
import '../features/profile/infrastructure/profile_facade.dart' as _i80;
import '../features/profile/profile.dart' as _i84;
import '../services/jwt_service.dart' as _i14;
import '../services/live_kit/live_kit_service.dart' as _i15;
import '../services/media_service.dart' as _i16;
import '../services/meno/meno_bloc.dart' as _i17;
import '../services/network_service.dart' as _i18;
import '../services/notification_service.dart' as _i53;
import '../services/objectbox_service.dart' as _i22;
import '../services/permissions_service.dart' as _i23;
import '../services/secure_storage_service.dart' as _i26;
import '../services/services.dart' as _i33;
import '../services/socket/socket_service.dart' as _i63;
import '../shared/session/cubit/session_cubit.dart' as _i62;
import '../shared/session/session_context.dart' as _i47;
import '../shared/shared.dart' as _i46;
import 'register_module.dart' as _i90;

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
    gh.singleton<_i5.BroadcastListMapper>(_i5.BroadcastListMapper());
    gh.singleton<_i6.BroadcastMapper>(_i6.BroadcastMapper());
    gh.lazySingleton<_i7.BroadcastRemoteDatasource>(
        () => registerModule.broadcastRemoteDatasource);
    gh.lazySingleton<_i8.DiscoverRemoteDatasource>(
        () => registerModule.discoverRemoteDatasource);
    gh.lazySingleton<_i9.FirebaseMessaging>(() => registerModule.fcm);
    gh.lazySingleton<_i10.FlutterLocalNotificationsPlugin>(
        () => registerModule.localNotifications);
    gh.lazySingleton<_i11.FlutterSecureStorage>(
        () => registerModule.secureStorage);
    gh.lazySingleton<_i12.ImagePicker>(() => registerModule.imagePicker);
    gh.lazySingleton<_i13.InternetConnectionChecker>(
        () => registerModule.internetChecker);
    gh.lazySingleton<_i14.JWTService>(() => _i14.JWTService());
    gh.lazySingleton<_i15.LiveKitService>(() => _i15.LiveKitService());
    gh.lazySingleton<_i16.MediaService>(
        () => _i16.MediaService(gh<_i12.ImagePicker>()));
    gh.lazySingleton<_i17.MenoBloc>(() => _i17.MenoBloc());
    gh.factory<_i18.NetworkService>(
        () => _i18.NetworkService(gh<_i13.InternetConnectionChecker>()));
    gh.lazySingleton<_i19.NoteRemoteDatasource>(
        () => registerModule.noteRemoteDatasource);
    gh.lazySingleton<_i20.NotificationRemoteDatasource>(
        () => registerModule.notificationRemoteDatasource);
    gh.singleton<_i21.NotificationsMapper>(_i21.NotificationsMapper());
    await gh.factoryAsync<_i22.ObjectBoxService>(
      () => registerModule.obj,
      preResolve: true,
    );
    await gh.factoryAsync<_i23.PermissionsService>(
      () {
        final i = _i23.PermissionsService();
        return i.checkPermissions().then((_) => i);
      },
      preResolve: true,
    );
    gh.singleton<_i24.ProfileMapper>(_i24.ProfileMapper());
    gh.lazySingleton<_i25.ProfileRemoteDatasource>(
        () => registerModule.profileRemoteDatasource);
    gh.lazySingleton<_i26.SecureStorageService>(
        () => _i26.SecureStorageService());
    await gh.factoryAsync<_i27.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i28.TimerCubit>(() => _i28.TimerCubit());
    gh.factory<_i29.AuthLocalDatasource>(() =>
        _i29.AuthLocalDatasource(storage: gh<_i26.SecureStorageService>()));
    gh.factory<_i30.BibleLocalDatasource>(() =>
        _i30.BibleLocalDatasource(objectBox: gh<_i22.ObjectBoxService>()));
    await gh.factoryAsync<_i31.IAuthFacade>(
      () {
        final i = _i32.AuthFacade(
          remoteDatasource: gh<_i31.AuthRemoteDatasource>(),
          localDatasource: gh<_i31.AuthLocalDatasource>(),
          networkService: gh<_i33.NetworkService>(),
          jwtService: gh<_i33.JWTService>(),
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
          network: gh<_i18.NetworkService>(),
        );
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.factory<_i37.IBroadcastFacade>(() => _i38.BroadcastFacade(
          mapper: gh<_i6.BroadcastMapper>(),
          listMapper: gh<_i5.BroadcastListMapper>(),
          remote: gh<_i7.BroadcastRemoteDatasource>(),
          network: gh<_i18.NetworkService>(),
        ));
    gh.factory<_i8.IDiscoverFacade>(() => _i39.DiscoverFacade(
          remote: gh<_i8.DiscoverRemoteDatasource>(),
          network: gh<_i18.NetworkService>(),
        ));
    gh.lazySingleton<_i40.INetworkFacade>(() =>
        _i41.NetworkFacade(connectivity: gh<_i13.InternetConnectionChecker>()));
    gh.lazySingleton<_i42.INotificationFacade>(() => _i43.NotificationFacade(
          remoteDatasource: gh<_i20.NotificationRemoteDatasource>(),
          networkService: gh<_i18.NetworkService>(),
        ));
    gh.factory<_i44.IOnboardingFacade>(
        () => _i45.OnboardingFacade(storage: gh<_i27.SharedPreferences>()));
    await gh.factoryAsync<_i46.ISessionContext>(
      () {
        final i = _i47.SessionContext(
          authFacade: gh<_i31.IAuthFacade>(),
          onboardingFacade: gh<_i48.IOnboardingFacade>(),
        );
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i49.LoginCubit>(() => _i49.LoginCubit(
          facade: gh<_i50.IAuthFacade>(),
          onboardingFacade: gh<_i48.IOnboardingFacade>(),
        ));
    gh.lazySingleton<_i51.NetworkCubit>(
        () => _i51.NetworkCubit(facade: gh<_i40.INetworkFacade>()));
    gh.factory<_i52.NoteLocalDatasource>(
        () => _i52.NoteLocalDatasource(pref: gh<_i27.SharedPreferences>()));
    await gh.factoryAsync<_i53.NotificationService>(
      () {
        final i = _i53.NotificationService(
          firebaseMessaging: gh<_i9.FirebaseMessaging>(),
          storageService: gh<_i26.SecureStorageService>(),
        );
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i54.OnboardingCubit>(
        () => _i54.OnboardingCubit(facade: gh<_i44.IOnboardingFacade>()));
    gh.factory<_i55.OnboardingLocalDatasource>(() =>
        _i55.OnboardingLocalDatasource(storage: gh<_i27.SharedPreferences>()));
    gh.factory<_i56.ProfileLocalDatasource>(() =>
        _i56.ProfileLocalDatasource(storage: gh<_i26.SecureStorageService>()));
    gh.lazySingleton<_i57.RecentlyLiveCubit>(
        () => _i57.RecentlyLiveCubit(facade: gh<_i37.IBroadcastFacade>()));
    gh.lazySingleton<_i58.RegisterCubit>(
        () => _i58.RegisterCubit(facade: gh<_i31.IAuthFacade>()));
    gh.lazySingleton<_i59.ResetPasswordCubit>(
        () => _i59.ResetPasswordCubit(facade: gh<_i50.IAuthFacade>()));
    gh.factory<_i60.ScripturePickerCubit>(
        () => _i60.ScripturePickerCubit(facade: gh<_i34.IBibleFacade>()));
    gh.lazySingleton<_i61.SearchBloc>(
        () => _i61.SearchBloc(facade: gh<_i8.IDiscoverFacade>()));
    await gh.factoryAsync<_i62.SessionCubit>(
      () {
        final i = _i62.SessionCubit(session: gh<_i46.ISessionContext>());
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    await gh.factoryAsync<_i63.SocketService>(
      () {
        final i = _i63.SocketService(facade: gh<_i50.IAuthFacade>());
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i64.StreamBloc>(() => _i64.StreamBloc(
          facade: gh<_i37.IBroadcastFacade>(),
          liveKit: gh<_i15.LiveKitService>(),
          socket: gh<_i63.SocketService>(),
          menoBloc: gh<_i17.MenoBloc>(),
          timer: gh<_i28.TimerCubit>(),
        ));
    gh.factory<_i65.TranslationsCubit>(
        () => _i65.TranslationsCubit(facade: gh<_i34.IBibleFacade>()));
    gh.factory<_i66.VersesCubit>(
        () => _i66.VersesCubit(facade: gh<_i34.IBibleFacade>()));
    gh.lazySingleton<_i67.AccountBloc>(
        () => _i67.AccountBloc(facade: gh<_i31.IAuthFacade>()));
    gh.factory<_i68.BibleBloc>(
        () => _i68.BibleBloc(facade: gh<_i34.IBibleFacade>()));
    gh.lazySingleton<_i69.BroadcastBloc>(() => _i69.BroadcastBloc(
          facade: gh<_i37.IBroadcastFacade>(),
          liveKit: gh<_i15.LiveKitService>(),
          socket: gh<_i63.SocketService>(),
          menoBloc: gh<_i17.MenoBloc>(),
          timer: gh<_i28.TimerCubit>(),
        ));
    gh.lazySingleton<_i70.BroadcastFormCubit>(() => _i70.BroadcastFormCubit(
          facade: gh<_i37.IBroadcastFacade>(),
          mediaService: gh<_i16.MediaService>(),
        ));
    gh.lazySingleton<_i71.ChatBloc>(() => _i71.ChatBloc(
          facade: gh<_i50.IAuthFacade>(),
          socket: gh<_i63.SocketService>(),
        )..init());
    gh.lazySingleton<_i72.DAllCubit>(
        () => _i72.DAllCubit(facade: gh<_i8.IDiscoverFacade>()));
    gh.lazySingleton<_i73.DNowLiveCubit>(
        () => _i73.DNowLiveCubit(facade: gh<_i8.IDiscoverFacade>()));
    gh.lazySingleton<_i74.DRecentlyLiveCubit>(
        () => _i74.DRecentlyLiveCubit(facade: gh<_i8.IDiscoverFacade>()));
    gh.lazySingleton<_i75.FilterBloc>(
        () => _i75.FilterBloc(facade: gh<_i8.IDiscoverFacade>()));
    gh.factory<_i76.INoteFacade>(() => _i77.NoteFacade(
          network: gh<_i18.NetworkService>(),
          local: gh<_i78.NoteLocalDatasource>(),
          remote: gh<_i78.NoteRemoteDatasource>(),
        ));
    gh.lazySingleton<_i79.IProfileFacade>(() => _i80.ProfileFacade(
          remote: gh<_i25.ProfileRemoteDatasource>(),
          local: gh<_i56.ProfileLocalDatasource>(),
          network: gh<_i18.NetworkService>(),
        ));
    gh.lazySingleton<_i81.LiveBroadcastsBloc>(
        () => _i81.LiveBroadcastsBloc(socket: gh<_i63.SocketService>()));
    gh.lazySingleton<_i82.LiveParticipantsBloc>(
        () => _i82.LiveParticipantsBloc(socket: gh<_i63.SocketService>()));
    gh.lazySingleton<_i83.MyProfileBloc>(
        () => _i83.MyProfileBloc(facade: gh<_i84.IProfileFacade>()));
    gh.factoryParam<_i85.NoteFormCubit, _i76.Note?, dynamic>((
      initialNote,
      _,
    ) =>
        _i85.NoteFormCubit(
          facade: gh<_i76.INoteFacade>(),
          initialNote: initialNote,
        ));
    gh.lazySingleton<_i86.NotesBloc>(
        () => _i86.NotesBloc(facade: gh<_i76.INoteFacade>()));
    gh.lazySingleton<_i87.ProfileFormCubit>(() => _i87.ProfileFormCubit(
          facade: gh<_i79.IProfileFacade>(),
          media: gh<_i16.MediaService>(),
        ));
    gh.lazySingleton<_i88.FolderFormCubit>(
        () => _i88.FolderFormCubit(facade: gh<_i76.INoteFacade>()));
    gh.lazySingleton<_i89.FolderListBloc>(
        () => _i89.FolderListBloc(facade: gh<_i76.INoteFacade>()));
    return this;
  }
}

class _$RegisterModule extends _i90.RegisterModule {}
