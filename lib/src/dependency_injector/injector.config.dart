// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_messaging/firebase_messaging.dart' as _i8;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i9;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i10;
import 'package:get_it/get_it.dart' as _i1;
import 'package:image_picker/image_picker.dart' as _i11;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i12;
import 'package:shared_preferences/shared_preferences.dart' as _i25;

import '../features/auth/application/account/account_cubit.dart' as _i51;
import '../features/auth/application/application.dart' as _i61;
import '../features/auth/application/auth/auth_bloc.dart' as _i52;
import '../features/auth/application/login/login_cubit.dart' as _i38;
import '../features/auth/application/register/register_cubit.dart' as _i47;
import '../features/auth/application/reset_password/reset_password_cubit.dart'
    as _i48;
import '../features/auth/domain/domain.dart' as _i28;
import '../features/auth/infrastructure/auth_facade.dart' as _i29;
import '../features/auth/infrastructure/datasources/auth_local_datasource.dart'
    as _i27;
import '../features/auth/infrastructure/datasources/auth_remote_datasource.dart'
    as _i4;
import '../features/auth/infrastructure/mapper/auth_mapper.dart' as _i3;
import '../features/broadcast/application/broadcast/broadcast_bloc.dart'
    as _i53;
import '../features/broadcast/application/broadcast_form/broadcast_form_cubit.dart'
    as _i54;
import '../features/broadcast/application/live_broadcasts/live_broadcasts_bloc.dart'
    as _i58;
import '../features/broadcast/application/live_participants/live_participants_bloc.dart'
    as _i59;
import '../features/broadcast/application/recently_live/recently_live_cubit.dart'
    as _i46;
import '../features/broadcast/application/stream/stream_bloc.dart' as _i50;
import '../features/broadcast/application/timer/timer_cubit.dart' as _i26;
import '../features/broadcast/domain/domain.dart' as _i30;
import '../features/broadcast/infrastructure/broadcast_facade.dart' as _i31;
import '../features/broadcast/infrastructure/datasources/broadcast_remote_datasource.dart'
    as _i7;
import '../features/broadcast/infrastructure/mapper/broadcast_list_mapper.dart'
    as _i5;
import '../features/broadcast/infrastructure/mapper/broadcast_mapper.dart'
    as _i6;
import '../features/chat/application/chat_bloc.dart' as _i55;
import '../features/network/application/network_cubit.dart' as _i40;
import '../features/network/domain/i_network_facade.dart' as _i32;
import '../features/network/infrastructure/network_facade.dart' as _i33;
import '../features/notes/infrastructure/datasources/note_local_datasource.dart'
    as _i41;
import '../features/notifications/domain/i_notification_facade.dart' as _i34;
import '../features/notifications/infrastructure/datasources/notification_remote_datasource.dart'
    as _i18;
import '../features/notifications/infrastructure/mapper/notifications_mapper.dart'
    as _i19;
import '../features/notifications/infrastructure/notification_facade.dart'
    as _i35;
import '../features/onboarding/application/onboarding_cubit.dart' as _i43;
import '../features/onboarding/domain/i_onboarding_facade.dart' as _i36;
import '../features/onboarding/infrastructure/onboarding_facade.dart' as _i37;
import '../features/onboarding/infrastructure/onboarding_local_datasource.dart'
    as _i44;
import '../features/onboarding/onboarding.dart' as _i39;
import '../features/profile/application/profile/my_profile_bloc.dart' as _i62;
import '../features/profile/application/profile_form/profile_form_cubit.dart'
    as _i64;
import '../features/profile/domain/domain.dart' as _i56;
import '../features/profile/infrastructure/datasources/profile_local_datasource.dart'
    as _i45;
import '../features/profile/infrastructure/datasources/profile_remote_datasource.dart'
    as _i23;
import '../features/profile/infrastructure/mapper/profile_mapper.dart' as _i22;
import '../features/profile/infrastructure/profile_facade.dart' as _i57;
import '../features/profile/profile.dart' as _i63;
import '../router/m_router.dart' as _i60;
import '../services/jwt_service.dart' as _i13;
import '../services/live_kit/live_kit_service.dart' as _i14;
import '../services/media_service.dart' as _i15;
import '../services/meno/meno_bloc.dart' as _i16;
import '../services/network_service.dart' as _i17;
import '../services/notification_service.dart' as _i42;
import '../services/objectbox_service.dart' as _i20;
import '../services/permissions_service.dart' as _i21;
import '../services/secure_storage_service.dart' as _i24;
import '../services/socket/socket_service.dart' as _i49;
import 'register_module.dart' as _i65;

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
    gh.singleton<_i5.BroadcastListMapper>(_i5.BroadcastListMapper());
    gh.singleton<_i6.BroadcastMapper>(_i6.BroadcastMapper());
    gh.lazySingleton<_i7.BroadcastRemoteDatasource>(
        () => registerModule.broadcastRemoteDatasource);
    gh.lazySingleton<_i8.FirebaseMessaging>(() => registerModule.fcm);
    gh.lazySingleton<_i9.FlutterLocalNotificationsPlugin>(
        () => registerModule.localNotifications);
    gh.lazySingleton<_i10.FlutterSecureStorage>(
        () => registerModule.secureStorage);
    gh.lazySingleton<_i11.ImagePicker>(() => registerModule.imagePicker);
    gh.lazySingleton<_i12.InternetConnectionChecker>(
        () => registerModule.internetChecker);
    gh.lazySingleton<_i13.JWTService>(() => _i13.JWTService());
    gh.lazySingleton<_i14.LiveKitService>(() => _i14.LiveKitService());
    gh.lazySingleton<_i15.MediaService>(
        () => _i15.MediaService(gh<_i11.ImagePicker>()));
    gh.lazySingleton<_i16.MenoBloc>(() => _i16.MenoBloc());
    gh.factory<_i17.NetworkService>(
        () => _i17.NetworkService(gh<_i12.InternetConnectionChecker>()));
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
    await gh.factoryAsync<_i28.IAuthFacade>(
      () {
        final i = _i29.AuthFacade(
          authMapper: gh<_i3.AuthMapper>(),
          remoteDatasource: gh<_i4.AuthRemoteDatasource>(),
          localDatasource: gh<_i27.AuthLocalDatasource>(),
          networkService: gh<_i17.NetworkService>(),
          jwtService: gh<_i13.JWTService>(),
        );
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i30.IBroadcastFacade>(() => _i31.BroadcastFacade(
          mapper: gh<_i6.BroadcastMapper>(),
          listMapper: gh<_i5.BroadcastListMapper>(),
          remote: gh<_i7.BroadcastRemoteDatasource>(),
          network: gh<_i17.NetworkService>(),
        ));
    gh.lazySingleton<_i32.INetworkFacade>(() =>
        _i33.NetworkFacade(connectivity: gh<_i12.InternetConnectionChecker>()));
    gh.lazySingleton<_i34.INotificationFacade>(() => _i35.NotificationFacade(
          remoteDatasource: gh<_i18.NotificationRemoteDatasource>(),
          networkService: gh<_i17.NetworkService>(),
        ));
    gh.factory<_i36.IOnboardingFacade>(
        () => _i37.OnboardingFacade(storage: gh<_i25.SharedPreferences>()));
    gh.lazySingleton<_i38.LoginCubit>(() => _i38.LoginCubit(
          facade: gh<_i28.IAuthFacade>(),
          onboardingFacade: gh<_i39.IOnboardingFacade>(),
        ));
    gh.lazySingleton<_i40.NetworkCubit>(
        () => _i40.NetworkCubit(facade: gh<_i32.INetworkFacade>()));
    gh.factory<_i41.NoteLocalDatasource>(
        () => _i41.NoteLocalDatasource(objectbox: gh<_i20.ObjectBoxService>()));
    await gh.factoryAsync<_i42.NotificationService>(
      () {
        final i = _i42.NotificationService(
          firebaseMessaging: gh<_i8.FirebaseMessaging>(),
          storageService: gh<_i24.SecureStorageService>(),
        );
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i43.OnboardingCubit>(
        () => _i43.OnboardingCubit(facade: gh<_i36.IOnboardingFacade>()));
    gh.factory<_i44.OnboardingLocalDatasource>(() =>
        _i44.OnboardingLocalDatasource(storage: gh<_i25.SharedPreferences>()));
    gh.factory<_i45.ProfileLocalDatasource>(() =>
        _i45.ProfileLocalDatasource(storage: gh<_i24.SecureStorageService>()));
    gh.lazySingleton<_i46.RecentlyLiveCubit>(
        () => _i46.RecentlyLiveCubit(facade: gh<_i30.IBroadcastFacade>()));
    gh.lazySingleton<_i47.RegisterCubit>(
        () => _i47.RegisterCubit(facade: gh<_i28.IAuthFacade>()));
    gh.lazySingleton<_i48.ResetPasswordCubit>(
        () => _i48.ResetPasswordCubit(facade: gh<_i28.IAuthFacade>()));
    await gh.factoryAsync<_i49.SocketService>(
      () {
        final i = _i49.SocketService(facade: gh<_i28.IAuthFacade>());
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i50.StreamBloc>(() => _i50.StreamBloc(
          facade: gh<_i30.IBroadcastFacade>(),
          liveKit: gh<_i14.LiveKitService>(),
          socket: gh<_i49.SocketService>(),
          menoBloc: gh<_i16.MenoBloc>(),
          timer: gh<_i26.TimerCubit>(),
        ));
    gh.factory<_i51.AccountCubit>(
        () => _i51.AccountCubit(facade: gh<_i28.IAuthFacade>()));
    gh.lazySingleton<_i52.AuthBloc>(() => _i52.AuthBloc(
          facade: gh<_i28.IAuthFacade>(),
          onboardingFacade: gh<_i39.IOnboardingFacade>(),
        ));
    gh.lazySingleton<_i53.BroadcastBloc>(() => _i53.BroadcastBloc(
          facade: gh<_i30.IBroadcastFacade>(),
          liveKit: gh<_i14.LiveKitService>(),
          socket: gh<_i49.SocketService>(),
          menoBloc: gh<_i16.MenoBloc>(),
          timer: gh<_i26.TimerCubit>(),
        ));
    gh.lazySingleton<_i54.BroadcastFormCubit>(() => _i54.BroadcastFormCubit(
          facade: gh<_i30.IBroadcastFacade>(),
          mediaService: gh<_i15.MediaService>(),
        ));
    gh.lazySingleton<_i55.ChatBloc>(() => _i55.ChatBloc(
          facade: gh<_i28.IAuthFacade>(),
          socket: gh<_i49.SocketService>(),
        )..init());
    gh.lazySingleton<_i56.IProfileFacade>(() => _i57.ProfileFacade(
          remote: gh<_i23.ProfileRemoteDatasource>(),
          local: gh<_i45.ProfileLocalDatasource>(),
          network: gh<_i17.NetworkService>(),
        ));
    gh.lazySingleton<_i58.LiveBroadcastsBloc>(
        () => _i58.LiveBroadcastsBloc(socket: gh<_i49.SocketService>()));
    gh.lazySingleton<_i59.LiveParticipantsBloc>(
        () => _i59.LiveParticipantsBloc(socket: gh<_i49.SocketService>()));
    gh.factory<_i60.MRouter>(() => _i60.MRouter(
          authBloc: gh<_i61.AuthBloc>(),
          onboardingCubit: gh<_i43.OnboardingCubit>(),
        ));
    gh.lazySingleton<_i62.MyProfileBloc>(
        () => _i62.MyProfileBloc(facade: gh<_i63.IProfileFacade>()));
    gh.lazySingleton<_i64.ProfileFormCubit>(() => _i64.ProfileFormCubit(
          facade: gh<_i56.IProfileFacade>(),
          media: gh<_i15.MediaService>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i65.RegisterModule {}
