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
import 'package:shared_preferences/shared_preferences.dart' as _i24;

import '../features/auth/application/account/account_bloc.dart' as _i65;
import '../features/auth/application/login/login_cubit.dart' as _i46;
import '../features/auth/application/register/register_cubit.dart' as _i56;
import '../features/auth/application/reset_password/reset_password_cubit.dart'
    as _i57;
import '../features/auth/auth.dart' as _i28;
import '../features/auth/domain/domain.dart' as _i47;
import '../features/auth/infrastructure/auth_facade.dart' as _i29;
import '../features/auth/infrastructure/datasources/auth_local_datasource.dart'
    as _i26;
import '../features/auth/infrastructure/datasources/auth_remote_datasource.dart'
    as _i3;
import '../features/bible/application/bible/bible_bloc.dart' as _i66;
import '../features/bible/application/scripture_picker/scripture_picker_cubit.dart'
    as _i58;
import '../features/bible/application/translations/translations_cubit.dart'
    as _i63;
import '../features/bible/application/verses/verses_cubit.dart' as _i64;
import '../features/bible/domain/domain.dart' as _i31;
import '../features/bible/infrastructure/bible_facade.dart' as _i32;
import '../features/bible/infrastructure/datasources/datasources.dart' as _i33;
import '../features/bible/infrastructure/datasources/local/bible_local_datasource.dart'
    as _i27;
import '../features/bible/infrastructure/datasources/remote/bible_remote_datasource.dart'
    as _i4;
import '../features/broadcast/application/broadcast/broadcast_bloc.dart'
    as _i67;
import '../features/broadcast/application/broadcast_form/broadcast_form_cubit.dart'
    as _i68;
import '../features/broadcast/application/live_broadcasts/live_broadcasts_bloc.dart'
    as _i78;
import '../features/broadcast/application/live_participants/live_participants_bloc.dart'
    as _i79;
import '../features/broadcast/application/recently_live/recently_live_cubit.dart'
    as _i54;
import '../features/broadcast/application/stream/stream_bloc.dart' as _i62;
import '../features/broadcast/application/timer/timer_cubit.dart' as _i25;
import '../features/broadcast/broadcast.dart' as _i34;
import '../features/broadcast/domain/domain.dart' as _i55;
import '../features/broadcast/infrastructure/broadcast_facade.dart' as _i35;
import '../features/broadcast/infrastructure/datasources/broadcast_remote_datasource.dart'
    as _i5;
import '../features/chat/application/chat_bloc.dart' as _i89;
import '../features/discover/application/all/d_all_cubit.dart' as _i69;
import '../features/discover/application/filter/filter_bloc.dart' as _i72;
import '../features/discover/application/now_live/d_now_live_cubit.dart'
    as _i70;
import '../features/discover/application/recently_live/d_recently_live_cubit.dart'
    as _i71;
import '../features/discover/application/search/search_bloc.dart' as _i59;
import '../features/discover/discover.dart' as _i6;
import '../features/discover/infrastructure/discover_facade.dart' as _i36;
import '../features/network/application/network_cubit.dart' as _i48;
import '../features/network/domain/i_network_facade.dart' as _i37;
import '../features/network/infrastructure/network_facade.dart' as _i38;
import '../features/notes/application/folder/folder_cubit.dart' as _i90;
import '../features/notes/application/folder_form/folder_form_cubit.dart'
    as _i91;
import '../features/notes/application/folder_list/folder_list_bloc.dart'
    as _i92;
import '../features/notes/application/note_form/note_form_cubit.dart' as _i85;
import '../features/notes/application/notes/notes_bloc.dart' as _i86;
import '../features/notes/domain/domain.dart' as _i73;
import '../features/notes/infrastructure/datasources/datasources.dart' as _i75;
import '../features/notes/infrastructure/datasources/note_local_datasource.dart'
    as _i49;
import '../features/notes/infrastructure/datasources/note_remote_datasource.dart'
    as _i16;
import '../features/notes/infrastructure/note_facade.dart' as _i74;
import '../features/notes/notes.dart' as _i87;
import '../features/notifications/domain/i_notification_facade.dart' as _i39;
import '../features/notifications/infrastructure/datasources/notification_remote_datasource.dart'
    as _i17;
import '../features/notifications/infrastructure/mapper/notifications_mapper.dart'
    as _i18;
import '../features/notifications/infrastructure/notification_facade.dart'
    as _i40;
import '../features/onboarding/application/onboarding_cubit.dart' as _i51;
import '../features/onboarding/domain/i_onboarding_facade.dart' as _i41;
import '../features/onboarding/infrastructure/onboarding_facade.dart' as _i42;
import '../features/onboarding/infrastructure/onboarding_local_datasource.dart'
    as _i52;
import '../features/onboarding/onboarding.dart' as _i45;
import '../features/profile/application/profile/my_profile_bloc.dart' as _i83;
import '../features/profile/application/profile_form/profile_form_cubit.dart'
    as _i88;
import '../features/profile/domain/domain.dart' as _i76;
import '../features/profile/infrastructure/datasources/profile_local_datasource.dart'
    as _i53;
import '../features/profile/infrastructure/datasources/profile_remote_datasource.dart'
    as _i22;
import '../features/profile/infrastructure/mapper/profile_mapper.dart' as _i21;
import '../features/profile/infrastructure/profile_facade.dart' as _i77;
import '../features/profile/profile.dart' as _i84;
import '../services/jwt_service.dart' as _i12;
import '../services/live_kit/live_kit.dart' as _i81;
import '../services/live_kit/live_kit_service.dart' as _i13;
import '../services/media_service.dart' as _i14;
import '../services/meno/meno_bloc.dart' as _i80;
import '../services/network_service.dart' as _i15;
import '../services/notification_service.dart' as _i50;
import '../services/objectbox_service.dart' as _i19;
import '../services/permissions_service.dart' as _i20;
import '../services/secure_storage_service.dart' as _i23;
import '../services/services.dart' as _i30;
import '../services/socket/socket.dart' as _i82;
import '../services/socket/socket_service.dart' as _i61;
import '../shared/session/cubit/session_cubit.dart' as _i60;
import '../shared/session/session_context.dart' as _i44;
import '../shared/shared.dart' as _i43;
import 'register_module.dart' as _i93;

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
    gh.factory<_i15.NetworkService>(
        () => _i15.NetworkService(gh<_i11.InternetConnectionChecker>()));
    gh.lazySingleton<_i16.NoteRemoteDatasource>(
        () => registerModule.noteRemoteDatasource);
    gh.lazySingleton<_i17.NotificationRemoteDatasource>(
        () => registerModule.notificationRemoteDatasource);
    gh.singleton<_i18.NotificationsMapper>(_i18.NotificationsMapper());
    await gh.factoryAsync<_i19.ObjectBoxService>(
      () => registerModule.obj,
      preResolve: true,
    );
    await gh.factoryAsync<_i20.PermissionsService>(
      () {
        final i = _i20.PermissionsService();
        return i.checkPermissions().then((_) => i);
      },
      preResolve: true,
    );
    gh.singleton<_i21.ProfileMapper>(_i21.ProfileMapper());
    gh.lazySingleton<_i22.ProfileRemoteDatasource>(
        () => registerModule.profileRemoteDatasource);
    gh.lazySingleton<_i23.SecureStorageService>(
        () => _i23.SecureStorageService());
    await gh.factoryAsync<_i24.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i25.TimerCubit>(() => _i25.TimerCubit());
    gh.factory<_i26.AuthLocalDatasource>(() =>
        _i26.AuthLocalDatasource(storage: gh<_i23.SecureStorageService>()));
    gh.factory<_i27.BibleLocalDatasource>(() =>
        _i27.BibleLocalDatasource(objectBox: gh<_i19.ObjectBoxService>()));
    await gh.factoryAsync<_i28.IAuthFacade>(
      () {
        final i = _i29.AuthFacade(
          remoteDatasource: gh<_i28.AuthRemoteDatasource>(),
          localDatasource: gh<_i28.AuthLocalDatasource>(),
          networkService: gh<_i30.NetworkService>(),
          jwtService: gh<_i30.JWTService>(),
        );
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    await gh.factoryAsync<_i31.IBibleFacade>(
      () {
        final i = _i32.BibleFacade(
          local: gh<_i33.BibleLocalDatasource>(),
          remote: gh<_i33.BibleRemoteDatasource>(),
          network: gh<_i15.NetworkService>(),
        );
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.factory<_i34.IBroadcastFacade>(() => _i35.BroadcastFacade(
          remote: gh<_i34.BroadcastRemoteDatasource>(),
          network: gh<_i30.NetworkService>(),
        ));
    gh.factory<_i6.IDiscoverFacade>(() => _i36.DiscoverFacade(
          remote: gh<_i6.DiscoverRemoteDatasource>(),
          network: gh<_i15.NetworkService>(),
        ));
    gh.lazySingleton<_i37.INetworkFacade>(() =>
        _i38.NetworkFacade(connectivity: gh<_i11.InternetConnectionChecker>()));
    gh.lazySingleton<_i39.INotificationFacade>(() => _i40.NotificationFacade(
          remoteDatasource: gh<_i17.NotificationRemoteDatasource>(),
          networkService: gh<_i15.NetworkService>(),
        ));
    gh.factory<_i41.IOnboardingFacade>(
        () => _i42.OnboardingFacade(storage: gh<_i24.SharedPreferences>()));
    await gh.factoryAsync<_i43.ISessionContext>(
      () {
        final i = _i44.SessionContext(
          authFacade: gh<_i28.IAuthFacade>(),
          onboardingFacade: gh<_i45.IOnboardingFacade>(),
        );
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i46.LoginCubit>(() => _i46.LoginCubit(
          facade: gh<_i47.IAuthFacade>(),
          onboardingFacade: gh<_i45.IOnboardingFacade>(),
        ));
    gh.lazySingleton<_i48.NetworkCubit>(
        () => _i48.NetworkCubit(facade: gh<_i37.INetworkFacade>()));
    gh.factory<_i49.NoteLocalDatasource>(
        () => _i49.NoteLocalDatasource(pref: gh<_i24.SharedPreferences>()));
    await gh.factoryAsync<_i50.NotificationService>(
      () {
        final i = _i50.NotificationService(
          firebaseMessaging: gh<_i7.FirebaseMessaging>(),
          storageService: gh<_i23.SecureStorageService>(),
        );
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i51.OnboardingCubit>(
        () => _i51.OnboardingCubit(facade: gh<_i41.IOnboardingFacade>()));
    gh.factory<_i52.OnboardingLocalDatasource>(() =>
        _i52.OnboardingLocalDatasource(storage: gh<_i24.SharedPreferences>()));
    gh.factory<_i53.ProfileLocalDatasource>(() =>
        _i53.ProfileLocalDatasource(storage: gh<_i23.SecureStorageService>()));
    gh.lazySingleton<_i54.RecentlyLiveCubit>(
        () => _i54.RecentlyLiveCubit(facade: gh<_i55.IBroadcastFacade>()));
    gh.lazySingleton<_i56.RegisterCubit>(
        () => _i56.RegisterCubit(facade: gh<_i28.IAuthFacade>()));
    gh.lazySingleton<_i57.ResetPasswordCubit>(
        () => _i57.ResetPasswordCubit(facade: gh<_i47.IAuthFacade>()));
    gh.factory<_i58.ScripturePickerCubit>(
        () => _i58.ScripturePickerCubit(facade: gh<_i31.IBibleFacade>()));
    gh.lazySingleton<_i59.SearchBloc>(
        () => _i59.SearchBloc(facade: gh<_i6.IDiscoverFacade>()));
    await gh.factoryAsync<_i60.SessionCubit>(
      () {
        final i = _i60.SessionCubit(session: gh<_i43.ISessionContext>());
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    await gh.factoryAsync<_i61.SocketService>(
      () {
        final i = _i61.SocketService(facade: gh<_i47.IAuthFacade>());
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.factory<_i62.StreamBloc>(() => _i62.StreamBloc(
          facade: gh<_i34.IBroadcastFacade>(),
          liveKit: gh<_i30.LiveKitService>(),
          socket: gh<_i30.SocketService>(),
        ));
    gh.factory<_i63.TranslationsCubit>(
        () => _i63.TranslationsCubit(facade: gh<_i31.IBibleFacade>()));
    gh.factory<_i64.VersesCubit>(
        () => _i64.VersesCubit(facade: gh<_i31.IBibleFacade>()));
    gh.lazySingleton<_i65.AccountBloc>(
        () => _i65.AccountBloc(facade: gh<_i28.IAuthFacade>()));
    gh.factory<_i66.BibleBloc>(
        () => _i66.BibleBloc(facade: gh<_i31.IBibleFacade>()));
    gh.factory<_i67.BroadcastBloc>(() => _i67.BroadcastBloc(
          facade: gh<_i34.IBroadcastFacade>(),
          liveKit: gh<_i30.LiveKitService>(),
          socket: gh<_i30.SocketService>(),
        ));
    gh.lazySingleton<_i68.BroadcastFormCubit>(() => _i68.BroadcastFormCubit(
          facade: gh<_i34.IBroadcastFacade>(),
          mediaService: gh<_i14.MediaService>(),
        ));
    gh.lazySingleton<_i69.DAllCubit>(
        () => _i69.DAllCubit(facade: gh<_i6.IDiscoverFacade>()));
    gh.lazySingleton<_i70.DNowLiveCubit>(
        () => _i70.DNowLiveCubit(facade: gh<_i6.IDiscoverFacade>()));
    gh.lazySingleton<_i71.DRecentlyLiveCubit>(
        () => _i71.DRecentlyLiveCubit(facade: gh<_i6.IDiscoverFacade>()));
    gh.lazySingleton<_i72.FilterBloc>(
        () => _i72.FilterBloc(facade: gh<_i6.IDiscoverFacade>()));
    gh.factory<_i73.INoteFacade>(() => _i74.NoteFacade(
          network: gh<_i15.NetworkService>(),
          local: gh<_i75.NoteLocalDatasource>(),
          remote: gh<_i75.NoteRemoteDatasource>(),
        ));
    gh.lazySingleton<_i76.IProfileFacade>(() => _i77.ProfileFacade(
          remote: gh<_i22.ProfileRemoteDatasource>(),
          local: gh<_i53.ProfileLocalDatasource>(),
          network: gh<_i15.NetworkService>(),
        ));
    gh.lazySingleton<_i78.LiveBroadcastsBloc>(
        () => _i78.LiveBroadcastsBloc(socket: gh<_i30.SocketService>()));
    gh.lazySingleton<_i79.LiveParticipantsBloc>(
        () => _i79.LiveParticipantsBloc(socket: gh<_i30.SocketService>()));
    gh.factory<_i80.MenoBloc>(() => _i80.MenoBloc(
          liveKit: gh<_i81.LiveKitService>(),
          socket: gh<_i82.SocketService>(),
        ));
    gh.lazySingleton<_i83.MyProfileBloc>(
        () => _i83.MyProfileBloc(facade: gh<_i84.IProfileFacade>()));
    gh.factoryParam<_i85.NoteFormCubit, _i73.Note?, dynamic>((
      initialNote,
      _,
    ) =>
        _i85.NoteFormCubit(
          facade: gh<_i73.INoteFacade>(),
          initialNote: initialNote,
        ));
    gh.lazySingleton<_i86.NotesBloc>(
        () => _i86.NotesBloc(facade: gh<_i87.INoteFacade>()));
    gh.lazySingleton<_i88.ProfileFormCubit>(() => _i88.ProfileFormCubit(
          facade: gh<_i76.IProfileFacade>(),
          media: gh<_i14.MediaService>(),
        ));
    gh.lazySingleton<_i89.ChatBloc>(() => _i89.ChatBloc(
          session: gh<_i43.ISessionContext>(),
          socket: gh<_i30.SocketService>(),
          profileFacade: gh<_i84.IProfileFacade>(),
        ));
    gh.factoryParam<_i90.FolderCubit, _i73.Folder, dynamic>((
      folder,
      _,
    ) =>
        _i90.FolderCubit(
          facade: gh<_i73.INoteFacade>(),
          folder: folder,
        ));
    gh.lazySingleton<_i91.FolderFormCubit>(
        () => _i91.FolderFormCubit(facade: gh<_i73.INoteFacade>()));
    gh.lazySingleton<_i92.FolderListBloc>(
        () => _i92.FolderListBloc(facade: gh<_i87.INoteFacade>()));
    return this;
  }
}

class _$RegisterModule extends _i93.RegisterModule {}
