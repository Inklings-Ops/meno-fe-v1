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
import 'package:shared_preferences/shared_preferences.dart' as _i24;

import '../features/auth/application/account/account_cubit.dart' as _i49;
import '../features/auth/application/application.dart' as _i61;
import '../features/auth/application/auth/auth_bloc.dart' as _i50;
import '../features/auth/application/login/login_cubit.dart' as _i37;
import '../features/auth/application/register/register_cubit.dart' as _i45;
import '../features/auth/application/reset_password/reset_password_cubit.dart'
    as _i46;
import '../features/auth/domain/domain.dart' as _i27;
import '../features/auth/infrastructure/auth_facade.dart' as _i28;
import '../features/auth/infrastructure/datasources/auth_local_datasource.dart'
    as _i26;
import '../features/auth/infrastructure/datasources/auth_remote_datasource.dart'
    as _i4;
import '../features/auth/infrastructure/mapper/auth_mapper.dart' as _i3;
import '../features/broadcast/application/broadcast/broadcast_bloc.dart'
    as _i51;
import '../features/broadcast/application/broadcast_form/broadcast_form_cubit.dart'
    as _i52;
import '../features/broadcast/application/live_broadcasts/live_broadcasts_bloc.dart'
    as _i58;
import '../features/broadcast/application/live_participants/live_participants_bloc.dart'
    as _i59;
import '../features/broadcast/application/recently_live/recently_live_cubit.dart'
    as _i44;
import '../features/broadcast/application/stream/stream_bloc.dart' as _i48;
import '../features/broadcast/application/timer/timer_cubit.dart' as _i25;
import '../features/broadcast/domain/domain.dart' as _i29;
import '../features/broadcast/infrastructure/broadcast_facade.dart' as _i30;
import '../features/broadcast/infrastructure/datasources/broadcast_remote_datasource.dart'
    as _i7;
import '../features/broadcast/infrastructure/mapper/broadcast_list_mapper.dart'
    as _i5;
import '../features/broadcast/infrastructure/mapper/broadcast_mapper.dart'
    as _i6;
import '../features/chat/application/chat_bloc.dart' as _i53;
import '../features/network/application/network_cubit.dart' as _i39;
import '../features/network/domain/i_network_facade.dart' as _i31;
import '../features/network/infrastructure/network_facade.dart' as _i32;
import '../features/notifications/domain/i_notification_facade.dart' as _i33;
import '../features/notifications/infrastructure/datasources/notification_remote_datasource.dart'
    as _i18;
import '../features/notifications/infrastructure/mapper/notifications_mapper.dart'
    as _i19;
import '../features/notifications/infrastructure/notification_facade.dart'
    as _i34;
import '../features/onboarding/application/onboarding_cubit.dart' as _i41;
import '../features/onboarding/domain/i_onboarding_facade.dart' as _i35;
import '../features/onboarding/infrastructure/onboarding_facade.dart' as _i36;
import '../features/onboarding/infrastructure/onboarding_local_datasource.dart'
    as _i42;
import '../features/onboarding/onboarding.dart' as _i38;
import '../features/profile/application/profile/my_profile_bloc.dart' as _i62;
import '../features/profile/application/profile_form/profile_form_cubit.dart'
    as _i64;
import '../features/profile/domain/domain.dart' as _i56;
import '../features/profile/infrastructure/datasources/profile_local_datasource.dart'
    as _i43;
import '../features/profile/infrastructure/datasources/profile_remote_datasource.dart'
    as _i22;
import '../features/profile/infrastructure/mapper/profile_mapper.dart' as _i21;
import '../features/profile/infrastructure/profile_facade.dart' as _i57;
import '../features/profile/profile.dart' as _i63;
import '../router/m_router.dart' as _i60;
import '../services/jwt_service.dart' as _i13;
import '../services/live_kit/live_kit_service.dart' as _i14;
import '../services/media_service.dart' as _i15;
import '../services/meno/meno_bloc.dart' as _i16;
import '../services/network_service.dart' as _i17;
import '../services/notification_service.dart' as _i40;
import '../services/permissions_service.dart' as _i20;
import '../services/secure_storage_service.dart' as _i23;
import '../services/socket/socket_service.dart' as _i47;
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
    await gh.factoryAsync<_i27.IAuthFacade>(
      () {
        final i = _i28.AuthFacade(
          authMapper: gh<_i3.AuthMapper>(),
          remoteDatasource: gh<_i4.AuthRemoteDatasource>(),
          localDatasource: gh<_i26.AuthLocalDatasource>(),
          networkService: gh<_i17.NetworkService>(),
          jwtService: gh<_i13.JWTService>(),
        );
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i29.IBroadcastFacade>(() => _i30.BroadcastFacade(
          mapper: gh<_i6.BroadcastMapper>(),
          listMapper: gh<_i5.BroadcastListMapper>(),
          remote: gh<_i7.BroadcastRemoteDatasource>(),
          network: gh<_i17.NetworkService>(),
        ));
    gh.lazySingleton<_i31.INetworkFacade>(() =>
        _i32.NetworkFacade(connectivity: gh<_i12.InternetConnectionChecker>()));
    gh.lazySingleton<_i33.INotificationFacade>(() => _i34.NotificationFacade(
          remoteDatasource: gh<_i18.NotificationRemoteDatasource>(),
          networkService: gh<_i17.NetworkService>(),
        ));
    gh.factory<_i35.IOnboardingFacade>(
        () => _i36.OnboardingFacade(storage: gh<_i24.SharedPreferences>()));
    gh.lazySingleton<_i37.LoginCubit>(() => _i37.LoginCubit(
          facade: gh<_i27.IAuthFacade>(),
          onboardingFacade: gh<_i38.IOnboardingFacade>(),
        ));
    gh.lazySingleton<_i39.NetworkCubit>(
        () => _i39.NetworkCubit(facade: gh<_i31.INetworkFacade>()));
    await gh.factoryAsync<_i40.NotificationService>(
      () {
        final i = _i40.NotificationService(
          firebaseMessaging: gh<_i8.FirebaseMessaging>(),
          storageService: gh<_i23.SecureStorageService>(),
        );
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i41.OnboardingCubit>(
        () => _i41.OnboardingCubit(facade: gh<_i35.IOnboardingFacade>()));
    gh.factory<_i42.OnboardingLocalDatasource>(() =>
        _i42.OnboardingLocalDatasource(storage: gh<_i24.SharedPreferences>()));
    gh.factory<_i43.ProfileLocalDatasource>(() =>
        _i43.ProfileLocalDatasource(storage: gh<_i23.SecureStorageService>()));
    gh.lazySingleton<_i44.RecentlyLiveCubit>(
        () => _i44.RecentlyLiveCubit(facade: gh<_i29.IBroadcastFacade>()));
    gh.lazySingleton<_i45.RegisterCubit>(
        () => _i45.RegisterCubit(facade: gh<_i27.IAuthFacade>()));
    gh.lazySingleton<_i46.ResetPasswordCubit>(
        () => _i46.ResetPasswordCubit(facade: gh<_i27.IAuthFacade>()));
    await gh.factoryAsync<_i47.SocketService>(
      () {
        final i = _i47.SocketService(facade: gh<_i27.IAuthFacade>());
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i48.StreamBloc>(() => _i48.StreamBloc(
          facade: gh<_i29.IBroadcastFacade>(),
          liveKit: gh<_i14.LiveKitService>(),
          socket: gh<_i47.SocketService>(),
          menoBloc: gh<_i16.MenoBloc>(),
          timer: gh<_i25.TimerCubit>(),
        ));
    gh.factory<_i49.AccountCubit>(
        () => _i49.AccountCubit(facade: gh<_i27.IAuthFacade>()));
    gh.lazySingleton<_i50.AuthBloc>(() => _i50.AuthBloc(
          facade: gh<_i27.IAuthFacade>(),
          onboardingFacade: gh<_i38.IOnboardingFacade>(),
        ));
    gh.lazySingleton<_i51.BroadcastBloc>(() => _i51.BroadcastBloc(
          facade: gh<_i29.IBroadcastFacade>(),
          liveKit: gh<_i14.LiveKitService>(),
          socket: gh<_i47.SocketService>(),
          menoBloc: gh<_i16.MenoBloc>(),
          timer: gh<_i25.TimerCubit>(),
        ));
    gh.lazySingleton<_i52.BroadcastFormCubit>(() => _i52.BroadcastFormCubit(
          facade: gh<_i29.IBroadcastFacade>(),
          mediaService: gh<_i15.MediaService>(),
        ));
    gh.lazySingleton<_i53.ChatBloc>(() => _i53.ChatBloc(
          facade: gh<_i27.IAuthFacade>(),
          socket: gh<_i47.SocketService>(),
        )..init());
    gh.lazySingleton<_i56.IProfileFacade>(() => _i57.ProfileFacade(
          remote: gh<_i22.ProfileRemoteDatasource>(),
          local: gh<_i43.ProfileLocalDatasource>(),
          network: gh<_i17.NetworkService>(),
        ));
    gh.lazySingleton<_i58.LiveBroadcastsBloc>(
        () => _i58.LiveBroadcastsBloc(socket: gh<_i47.SocketService>()));
    gh.lazySingleton<_i59.LiveParticipantsBloc>(
        () => _i59.LiveParticipantsBloc(socket: gh<_i47.SocketService>()));
    gh.factory<_i60.MRouter>(() => _i60.MRouter(
          authBloc: gh<_i61.AuthBloc>(),
          onboardingCubit: gh<_i41.OnboardingCubit>(),
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
