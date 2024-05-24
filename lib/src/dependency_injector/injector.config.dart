// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_messaging/firebase_messaging.dart' as _i19;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i20;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i21;
import 'package:get_it/get_it.dart' as _i1;
import 'package:image_picker/image_picker.dart' as _i17;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i16;
import 'package:shared_preferences/shared_preferences.dart' as _i3;

import '../features/auth/application/account/account_cubit.dart' as _i69;
import '../features/auth/application/application.dart' as _i61;
import '../features/auth/application/auth/auth_bloc.dart' as _i57;
import '../features/auth/application/login/login_cubit.dart' as _i59;
import '../features/auth/application/register/register_cubit.dart' as _i67;
import '../features/auth/application/reset_password/reset_password_cubit.dart'
    as _i68;
import '../features/auth/domain/domain.dart' as _i46;
import '../features/auth/infrastructure/auth_facade.dart' as _i47;
import '../features/auth/infrastructure/datasources/auth_local_datasource.dart'
    as _i32;
import '../features/auth/infrastructure/datasources/auth_remote_datasource.dart'
    as _i11;
import '../features/auth/infrastructure/mapper/auth_mapper.dart' as _i6;
import '../features/bible/application/bible/bible_bloc.dart' as _i62;
import '../features/bible/application/scripture_picker/scripture_picker_cubit.dart'
    as _i63;
import '../features/bible/application/translations/translations_cubit.dart'
    as _i64;
import '../features/bible/application/verses/verses_cubit.dart' as _i65;
import '../features/bible/domain/domain.dart' as _i36;
import '../features/bible/infrastructure/bible_facade.dart' as _i37;
import '../features/bible/infrastructure/datasources/datasources.dart' as _i38;
import '../features/bible/infrastructure/datasources/local/bible_local_datasource.dart'
    as _i28;
import '../features/bible/infrastructure/datasources/remote/bible_remote_datasource.dart'
    as _i15;
import '../features/broadcast/application/broadcast/broadcast_bloc.dart'
    as _i75;
import '../features/broadcast/application/broadcast_form/broadcast_form_cubit.dart'
    as _i45;
import '../features/broadcast/application/live_broadcasts/live_broadcasts_bloc.dart'
    as _i78;
import '../features/broadcast/application/live_participants/live_participants_bloc.dart'
    as _i79;
import '../features/broadcast/application/recently_live/recently_live_cubit.dart'
    as _i42;
import '../features/broadcast/application/stream/stream_bloc.dart' as _i76;
import '../features/broadcast/application/timer/timer_cubit.dart' as _i22;
import '../features/broadcast/domain/domain.dart' as _i39;
import '../features/broadcast/infrastructure/broadcast_facade.dart' as _i40;
import '../features/broadcast/infrastructure/datasources/broadcast_remote_datasource.dart'
    as _i12;
import '../features/broadcast/infrastructure/mapper/broadcast_list_mapper.dart'
    as _i7;
import '../features/broadcast/infrastructure/mapper/broadcast_mapper.dart'
    as _i8;
import '../features/chat/application/chat_bloc.dart' as _i77;
import '../features/network/application/network_cubit.dart' as _i51;
import '../features/network/domain/i_network_facade.dart' as _i43;
import '../features/network/infrastructure/network_facade.dart' as _i44;
import '../features/notes/application/note_form/note_form_cubit.dart' as _i73;
import '../features/notes/application/note_list/note_list_bloc.dart' as _i74;
import '../features/notes/domain/domain.dart' as _i52;
import '../features/notes/infrastructure/datasources/datasources.dart' as _i54;
import '../features/notes/infrastructure/datasources/note_local_datasource.dart'
    as _i34;
import '../features/notes/infrastructure/datasources/note_remote_datasource.dart'
    as _i14;
import '../features/notes/infrastructure/note_facade.dart' as _i53;
import '../features/notifications/domain/i_notification_facade.dart' as _i49;
import '../features/notifications/infrastructure/datasources/notification_remote_datasource.dart'
    as _i13;
import '../features/notifications/infrastructure/mapper/notifications_mapper.dart'
    as _i9;
import '../features/notifications/infrastructure/notification_facade.dart'
    as _i50;
import '../features/onboarding/application/onboarding_cubit.dart' as _i48;
import '../features/onboarding/domain/i_onboarding_facade.dart' as _i29;
import '../features/onboarding/infrastructure/onboarding_facade.dart' as _i30;
import '../features/onboarding/infrastructure/onboarding_local_datasource.dart'
    as _i27;
import '../features/onboarding/onboarding.dart' as _i58;
import '../features/profile/application/profile/my_profile_bloc.dart' as _i71;
import '../features/profile/application/profile_form/profile_form_cubit.dart'
    as _i66;
import '../features/profile/domain/domain.dart' as _i55;
import '../features/profile/infrastructure/datasources/profile_local_datasource.dart'
    as _i33;
import '../features/profile/infrastructure/datasources/profile_remote_datasource.dart'
    as _i18;
import '../features/profile/infrastructure/mapper/profile_mapper.dart' as _i10;
import '../features/profile/infrastructure/profile_facade.dart' as _i56;
import '../features/profile/profile.dart' as _i72;
import '../router/m_router.dart' as _i60;
import '../services/jwt_service.dart' as _i23;
import '../services/live_kit/live_kit_service.dart' as _i24;
import '../services/media_service.dart' as _i41;
import '../services/meno/meno_bloc.dart' as _i25;
import '../services/network_service.dart' as _i35;
import '../services/notification_service.dart' as _i31;
import '../services/objectbox_service.dart' as _i4;
import '../services/permissions_service.dart' as _i5;
import '../services/secure_storage_service.dart' as _i26;
import '../services/socket/socket_service.dart' as _i70;
import 'register_module.dart' as _i80;

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
    await gh.factoryAsync<_i3.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    await gh.factoryAsync<_i4.ObjectBoxService>(
      () => registerModule.obj,
      preResolve: true,
    );
    await gh.factoryAsync<_i5.PermissionsService>(
      () {
        final i = _i5.PermissionsService();
        return i.checkPermissions().then((_) => i);
      },
      preResolve: true,
    );
    gh.singleton<_i6.AuthMapper>(() => _i6.AuthMapper());
    gh.singleton<_i7.BroadcastListMapper>(() => _i7.BroadcastListMapper());
    gh.singleton<_i8.BroadcastMapper>(() => _i8.BroadcastMapper());
    gh.singleton<_i9.NotificationsMapper>(() => _i9.NotificationsMapper());
    gh.singleton<_i10.ProfileMapper>(() => _i10.ProfileMapper());
    gh.lazySingleton<_i11.AuthRemoteDatasource>(
        () => registerModule.authRemoteDatasource);
    gh.lazySingleton<_i12.BroadcastRemoteDatasource>(
        () => registerModule.broadcastRemoteDatasource);
    gh.lazySingleton<_i13.NotificationRemoteDatasource>(
        () => registerModule.notificationRemoteDatasource);
    gh.lazySingleton<_i14.NoteRemoteDatasource>(
        () => registerModule.noteRemoteDatasource);
    gh.lazySingleton<_i15.BibleRemoteDatasource>(
        () => registerModule.bibleRemoteDatasource);
    gh.lazySingleton<_i16.InternetConnectionChecker>(
        () => registerModule.internetChecker);
    gh.lazySingleton<_i17.ImagePicker>(() => registerModule.imagePicker);
    gh.lazySingleton<_i18.ProfileRemoteDatasource>(
        () => registerModule.profileRemoteDatasource);
    gh.lazySingleton<_i19.FirebaseMessaging>(() => registerModule.fcm);
    gh.lazySingleton<_i20.FlutterLocalNotificationsPlugin>(
        () => registerModule.localNotifications);
    gh.lazySingleton<_i21.FlutterSecureStorage>(
        () => registerModule.secureStorage);
    gh.lazySingleton<_i22.TimerCubit>(() => _i22.TimerCubit());
    gh.lazySingleton<_i23.JWTService>(() => _i23.JWTService());
    gh.lazySingleton<_i24.LiveKitService>(() => _i24.LiveKitService());
    gh.lazySingleton<_i25.MenoBloc>(() => _i25.MenoBloc());
    gh.lazySingleton<_i26.SecureStorageService>(
        () => _i26.SecureStorageService());
    gh.factory<_i27.OnboardingLocalDatasource>(() =>
        _i27.OnboardingLocalDatasource(storage: gh<_i3.SharedPreferences>()));
    gh.factory<_i28.BibleLocalDatasource>(
        () => _i28.BibleLocalDatasource(objectBox: gh<_i4.ObjectBoxService>()));
    gh.factory<_i29.IOnboardingFacade>(
        () => _i30.OnboardingFacade(storage: gh<_i3.SharedPreferences>()));
    await gh.factoryAsync<_i31.NotificationService>(
      () {
        final i = _i31.NotificationService(
          firebaseMessaging: gh<_i19.FirebaseMessaging>(),
          storageService: gh<_i26.SecureStorageService>(),
        );
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.factory<_i32.AuthLocalDatasource>(() =>
        _i32.AuthLocalDatasource(storage: gh<_i26.SecureStorageService>()));
    gh.factory<_i33.ProfileLocalDatasource>(() =>
        _i33.ProfileLocalDatasource(storage: gh<_i26.SecureStorageService>()));
    gh.factory<_i34.NoteLocalDatasource>(
        () => _i34.NoteLocalDatasource(objectbox: gh<_i4.ObjectBoxService>()));
    gh.factory<_i35.NetworkService>(
        () => _i35.NetworkService(gh<_i16.InternetConnectionChecker>()));
    await gh.factoryAsync<_i36.IBibleFacade>(
      () {
        final i = _i37.BibleFacade(
          local: gh<_i38.BibleLocalDatasource>(),
          remote: gh<_i38.BibleRemoteDatasource>(),
          network: gh<_i35.NetworkService>(),
        );
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i39.IBroadcastFacade>(() => _i40.BroadcastFacade(
          mapper: gh<_i8.BroadcastMapper>(),
          listMapper: gh<_i7.BroadcastListMapper>(),
          remote: gh<_i12.BroadcastRemoteDatasource>(),
          network: gh<_i35.NetworkService>(),
        ));
    gh.lazySingleton<_i41.MediaService>(
        () => _i41.MediaService(gh<_i17.ImagePicker>()));
    gh.lazySingleton<_i42.RecentlyLiveCubit>(
        () => _i42.RecentlyLiveCubit(facade: gh<_i39.IBroadcastFacade>()));
    gh.lazySingleton<_i43.INetworkFacade>(() =>
        _i44.NetworkFacade(connectivity: gh<_i16.InternetConnectionChecker>()));
    gh.lazySingleton<_i45.BroadcastFormCubit>(() => _i45.BroadcastFormCubit(
          facade: gh<_i39.IBroadcastFacade>(),
          mediaService: gh<_i41.MediaService>(),
        ));
    await gh.factoryAsync<_i46.IAuthFacade>(
      () {
        final i = _i47.AuthFacade(
          authMapper: gh<_i6.AuthMapper>(),
          remoteDatasource: gh<_i11.AuthRemoteDatasource>(),
          localDatasource: gh<_i32.AuthLocalDatasource>(),
          networkService: gh<_i35.NetworkService>(),
          jwtService: gh<_i23.JWTService>(),
        );
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i48.OnboardingCubit>(
        () => _i48.OnboardingCubit(facade: gh<_i29.IOnboardingFacade>()));
    gh.lazySingleton<_i49.INotificationFacade>(() => _i50.NotificationFacade(
          remoteDatasource: gh<_i13.NotificationRemoteDatasource>(),
          networkService: gh<_i35.NetworkService>(),
        ));
    gh.lazySingleton<_i51.NetworkCubit>(
        () => _i51.NetworkCubit(facade: gh<_i43.INetworkFacade>()));
    gh.factory<_i52.INoteFacade>(() => _i53.NoteFacade(
          network: gh<_i35.NetworkService>(),
          local: gh<_i54.NoteLocalDatasource>(),
          remote: gh<_i54.NoteRemoteDatasource>(),
        ));
    gh.lazySingleton<_i55.IProfileFacade>(() => _i56.ProfileFacade(
          remote: gh<_i18.ProfileRemoteDatasource>(),
          local: gh<_i33.ProfileLocalDatasource>(),
          network: gh<_i35.NetworkService>(),
        ));
    gh.lazySingleton<_i57.AuthBloc>(() => _i57.AuthBloc(
          facade: gh<_i46.IAuthFacade>(),
          onboardingFacade: gh<_i58.IOnboardingFacade>(),
        ));
    gh.lazySingleton<_i59.LoginCubit>(() => _i59.LoginCubit(
          facade: gh<_i46.IAuthFacade>(),
          onboardingFacade: gh<_i58.IOnboardingFacade>(),
        ));
    gh.factory<_i60.MRouter>(() => _i60.MRouter(
          authBloc: gh<_i61.AuthBloc>(),
          onboardingCubit: gh<_i48.OnboardingCubit>(),
        ));
    gh.factory<_i62.BibleBloc>(
        () => _i62.BibleBloc(facade: gh<_i36.IBibleFacade>()));
    gh.factory<_i63.ScripturePickerCubit>(
        () => _i63.ScripturePickerCubit(facade: gh<_i36.IBibleFacade>()));
    gh.factory<_i64.TranslationsCubit>(
        () => _i64.TranslationsCubit(facade: gh<_i36.IBibleFacade>()));
    gh.factory<_i65.VersesCubit>(
        () => _i65.VersesCubit(facade: gh<_i36.IBibleFacade>()));
    gh.lazySingleton<_i66.ProfileFormCubit>(() => _i66.ProfileFormCubit(
          facade: gh<_i55.IProfileFacade>(),
          media: gh<_i41.MediaService>(),
        ));
    gh.lazySingleton<_i67.RegisterCubit>(
        () => _i67.RegisterCubit(facade: gh<_i46.IAuthFacade>()));
    gh.lazySingleton<_i68.ResetPasswordCubit>(
        () => _i68.ResetPasswordCubit(facade: gh<_i46.IAuthFacade>()));
    gh.factory<_i69.AccountCubit>(
        () => _i69.AccountCubit(facade: gh<_i46.IAuthFacade>()));
    await gh.factoryAsync<_i70.SocketService>(
      () {
        final i = _i70.SocketService(facade: gh<_i46.IAuthFacade>());
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i71.MyProfileBloc>(
        () => _i71.MyProfileBloc(facade: gh<_i72.IProfileFacade>()));
    gh.lazySingleton<_i73.NoteFormCubit>(
        () => _i73.NoteFormCubit(facade: gh<_i52.INoteFacade>()));
    gh.lazySingleton<_i74.NoteListBloc>(
        () => _i74.NoteListBloc(facade: gh<_i52.INoteFacade>()));
    gh.lazySingleton<_i75.BroadcastBloc>(() => _i75.BroadcastBloc(
          facade: gh<_i39.IBroadcastFacade>(),
          liveKit: gh<_i24.LiveKitService>(),
          socket: gh<_i70.SocketService>(),
          menoBloc: gh<_i25.MenoBloc>(),
          timer: gh<_i22.TimerCubit>(),
        ));
    gh.lazySingleton<_i76.StreamBloc>(() => _i76.StreamBloc(
          facade: gh<_i39.IBroadcastFacade>(),
          liveKit: gh<_i24.LiveKitService>(),
          socket: gh<_i70.SocketService>(),
          menoBloc: gh<_i25.MenoBloc>(),
          timer: gh<_i22.TimerCubit>(),
        ));
    gh.lazySingleton<_i77.ChatBloc>(() => _i77.ChatBloc(
          facade: gh<_i46.IAuthFacade>(),
          socket: gh<_i70.SocketService>(),
        )..init());
    gh.lazySingleton<_i78.LiveBroadcastsBloc>(
        () => _i78.LiveBroadcastsBloc(socket: gh<_i70.SocketService>()));
    gh.lazySingleton<_i79.LiveParticipantsBloc>(
        () => _i79.LiveParticipantsBloc(socket: gh<_i70.SocketService>()));
    return this;
  }
}

class _$RegisterModule extends _i80.RegisterModule {}
