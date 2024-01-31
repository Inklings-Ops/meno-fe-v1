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
import 'package:shared_preferences/shared_preferences.dart' as _i23;

import '../features/auth/application/account/account_cubit.dart' as _i50;
import '../features/auth/application/application.dart' as _i59;
import '../features/auth/application/auth/auth_bloc.dart' as _i51;
import '../features/auth/application/login/login_cubit.dart' as _i38;
import '../features/auth/application/register/register_cubit.dart' as _i46;
import '../features/auth/application/reset_password/reset_password_cubit.dart'
    as _i47;
import '../features/auth/domain/domain.dart' as _i26;
import '../features/auth/infrastructure/auth_facade.dart' as _i27;
import '../features/auth/infrastructure/datasources/auth_local_datasource.dart'
    as _i25;
import '../features/auth/infrastructure/datasources/auth_remote_datasource.dart'
    as _i4;
import '../features/auth/infrastructure/mapper/auth_mapper.dart' as _i3;
import '../features/broadcast/application/broadcast/broadcast_bloc.dart'
    as _i52;
import '../features/broadcast/application/broadcast_form/broadcast_form_cubit.dart'
    as _i53;
import '../features/broadcast/application/live_broadcasts/live_broadcasts_bloc.dart'
    as _i56;
import '../features/broadcast/application/live_participants/live_participants_bloc.dart'
    as _i57;
import '../features/broadcast/application/recently_live/recently_live_cubit.dart'
    as _i45;
import '../features/broadcast/application/stream/stream_bloc.dart' as _i49;
import '../features/broadcast/application/timer/timer_cubit.dart' as _i24;
import '../features/broadcast/domain/domain.dart' as _i28;
import '../features/broadcast/infrastructure/broadcast_facade.dart' as _i29;
import '../features/broadcast/infrastructure/datasources/broadcast_remote_datasource.dart'
    as _i7;
import '../features/broadcast/infrastructure/mapper/broadcast_list_mapper.dart'
    as _i5;
import '../features/broadcast/infrastructure/mapper/broadcast_mapper.dart'
    as _i6;
import '../features/network/application/network_cubit.dart' as _i40;
import '../features/network/domain/i_network_facade.dart' as _i30;
import '../features/network/infrastructure/network_facade.dart' as _i31;
import '../features/notifications/domain/i_notification_facade.dart' as _i32;
import '../features/notifications/infrastructure/datasources/notification_remote_datasource.dart'
    as _i17;
import '../features/notifications/infrastructure/mapper/notifications_mapper.dart'
    as _i18;
import '../features/notifications/infrastructure/notification_facade.dart'
    as _i33;
import '../features/onboarding/application/onboarding_cubit.dart' as _i42;
import '../features/onboarding/domain/i_onboarding_facade.dart' as _i34;
import '../features/onboarding/infrastructure/onboarding_facade.dart' as _i35;
import '../features/onboarding/infrastructure/onboarding_local_datasource.dart'
    as _i43;
import '../features/onboarding/onboarding.dart' as _i39;
import '../features/profile/application/profile/my_profile_bloc.dart' as _i60;
import '../features/profile/application/profile_form/profile_form_cubit.dart'
    as _i62;
import '../features/profile/domain/domain.dart' as _i54;
import '../features/profile/infrastructure/datasources/profile_local_datasource.dart'
    as _i44;
import '../features/profile/infrastructure/datasources/profile_remote_datasource.dart'
    as _i21;
import '../features/profile/infrastructure/mapper/profile_mapper.dart' as _i20;
import '../features/profile/infrastructure/profile_facade.dart' as _i55;
import '../features/profile/profile.dart' as _i61;
import '../router/m_router.dart' as _i58;
import '../services/jwt_service.dart' as _i13;
import '../services/live_kit/live_kit_service.dart' as _i37;
import '../services/media_service.dart' as _i14;
import '../services/meno/meno_bloc.dart' as _i15;
import '../services/network_service.dart' as _i16;
import '../services/notification_service.dart' as _i41;
import '../services/permissions_service.dart' as _i19;
import '../services/secure_storage_service.dart' as _i22;
import '../services/socket/socket_service.dart' as _i48;
import 'register_module.dart' as _i63;

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
    gh.lazySingleton<_i14.MediaService>(
        () => _i14.MediaService(gh<_i11.ImagePicker>()));
    gh.lazySingleton<_i15.MenoBloc>(() => _i15.MenoBloc());
    gh.factory<_i16.NetworkService>(
        () => _i16.NetworkService(gh<_i12.InternetConnectionChecker>()));
    gh.lazySingleton<_i17.NotificationRemoteDatasource>(
        () => registerModule.notificationRemoteDatasource);
    gh.singleton<_i18.NotificationsMapper>(_i18.NotificationsMapper());
    await gh.factoryAsync<_i19.PermissionsService>(
      () {
        final i = _i19.PermissionsService();
        return i.checkPermissions().then((_) => i);
      },
      preResolve: true,
    );
    gh.singleton<_i20.ProfileMapper>(_i20.ProfileMapper());
    gh.lazySingleton<_i21.ProfileRemoteDatasource>(
        () => registerModule.profileRemoteDatasource);
    gh.lazySingleton<_i22.SecureStorageService>(
        () => _i22.SecureStorageService());
    await gh.factoryAsync<_i23.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i24.TimerCubit>(() => _i24.TimerCubit());
    gh.factory<_i25.AuthLocalDatasource>(() =>
        _i25.AuthLocalDatasource(storage: gh<_i22.SecureStorageService>()));
    await gh.factoryAsync<_i26.IAuthFacade>(
      () {
        final i = _i27.AuthFacade(
          authMapper: gh<_i3.AuthMapper>(),
          remoteDatasource: gh<_i4.AuthRemoteDatasource>(),
          localDatasource: gh<_i25.AuthLocalDatasource>(),
          networkService: gh<_i16.NetworkService>(),
          jwtService: gh<_i13.JWTService>(),
        );
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i28.IBroadcastFacade>(() => _i29.BroadcastFacade(
          mapper: gh<_i6.BroadcastMapper>(),
          listMapper: gh<_i5.BroadcastListMapper>(),
          remote: gh<_i7.BroadcastRemoteDatasource>(),
          network: gh<_i16.NetworkService>(),
        ));
    gh.lazySingleton<_i30.INetworkFacade>(() =>
        _i31.NetworkFacade(connectivity: gh<_i12.InternetConnectionChecker>()));
    gh.lazySingleton<_i32.INotificationFacade>(() => _i33.NotificationFacade(
          remoteDatasource: gh<_i17.NotificationRemoteDatasource>(),
          networkService: gh<_i16.NetworkService>(),
        ));
    gh.factory<_i34.IOnboardingFacade>(
        () => _i35.OnboardingFacade(storage: gh<_i23.SharedPreferences>()));
    gh.lazySingleton<_i37.LiveKitService>(() => _i37.LiveKitService());
    gh.lazySingleton<_i38.LoginCubit>(() => _i38.LoginCubit(
          facade: gh<_i26.IAuthFacade>(),
          onboardingFacade: gh<_i39.IOnboardingFacade>(),
        ));
    gh.lazySingleton<_i40.NetworkCubit>(
        () => _i40.NetworkCubit(facade: gh<_i30.INetworkFacade>()));
    await gh.factoryAsync<_i41.NotificationService>(
      () {
        final i = _i41.NotificationService(
          firebaseMessaging: gh<_i8.FirebaseMessaging>(),
          storageService: gh<_i22.SecureStorageService>(),
        );
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i42.OnboardingCubit>(
        () => _i42.OnboardingCubit(facade: gh<_i34.IOnboardingFacade>()));
    gh.factory<_i43.OnboardingLocalDatasource>(() =>
        _i43.OnboardingLocalDatasource(storage: gh<_i23.SharedPreferences>()));
    gh.factory<_i44.ProfileLocalDatasource>(() =>
        _i44.ProfileLocalDatasource(storage: gh<_i22.SecureStorageService>()));
    gh.lazySingleton<_i45.RecentlyLiveCubit>(
        () => _i45.RecentlyLiveCubit(facade: gh<_i28.IBroadcastFacade>()));
    gh.lazySingleton<_i46.RegisterCubit>(
        () => _i46.RegisterCubit(facade: gh<_i26.IAuthFacade>()));
    gh.lazySingleton<_i47.ResetPasswordCubit>(
        () => _i47.ResetPasswordCubit(facade: gh<_i26.IAuthFacade>()));
    await gh.factoryAsync<_i48.SocketService>(
      () {
        final i = _i48.SocketService(facade: gh<_i26.IAuthFacade>());
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i49.StreamBloc>(() => _i49.StreamBloc(
          facade: gh<_i28.IBroadcastFacade>(),
          liveKit: gh<_i37.LiveKitService>(),
          socket: gh<_i48.SocketService>(),
          menoBloc: gh<_i15.MenoBloc>(),
          timer: gh<_i24.TimerCubit>(),
        ));
    gh.factory<_i50.AccountCubit>(
        () => _i50.AccountCubit(facade: gh<_i26.IAuthFacade>()));
    gh.lazySingleton<_i51.AuthBloc>(() => _i51.AuthBloc(
          facade: gh<_i26.IAuthFacade>(),
          onboardingFacade: gh<_i39.IOnboardingFacade>(),
        ));
    gh.lazySingleton<_i52.BroadcastBloc>(() => _i52.BroadcastBloc(
          facade: gh<_i28.IBroadcastFacade>(),
          liveKit: gh<_i37.LiveKitService>(),
          socket: gh<_i48.SocketService>(),
          menoBloc: gh<_i15.MenoBloc>(),
          timer: gh<_i24.TimerCubit>(),
        ));
    gh.lazySingleton<_i53.BroadcastFormCubit>(() => _i53.BroadcastFormCubit(
          facade: gh<_i28.IBroadcastFacade>(),
          mediaService: gh<_i14.MediaService>(),
        ));
    gh.lazySingleton<_i54.IProfileFacade>(() => _i55.ProfileFacade(
          remote: gh<_i21.ProfileRemoteDatasource>(),
          local: gh<_i44.ProfileLocalDatasource>(),
          network: gh<_i16.NetworkService>(),
        ));
    gh.lazySingleton<_i56.LiveBroadcastsBloc>(
        () => _i56.LiveBroadcastsBloc(socket: gh<_i48.SocketService>()));
    gh.lazySingleton<_i57.LiveParticipantsBloc>(
        () => _i57.LiveParticipantsBloc(socket: gh<_i48.SocketService>()));
    gh.factory<_i58.MRouter>(() => _i58.MRouter(
          authBloc: gh<_i59.AuthBloc>(),
          onboardingCubit: gh<_i42.OnboardingCubit>(),
        ));
    gh.lazySingleton<_i60.MyProfileBloc>(
        () => _i60.MyProfileBloc(facade: gh<_i61.IProfileFacade>()));
    gh.lazySingleton<_i62.ProfileFormCubit>(() => _i62.ProfileFormCubit(
          facade: gh<_i54.IProfileFacade>(),
          media: gh<_i14.MediaService>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i63.RegisterModule {}
