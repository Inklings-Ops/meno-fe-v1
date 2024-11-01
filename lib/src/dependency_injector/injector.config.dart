// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../meno.dart' as _i1014;
import '../core/network/application/network_cubit.dart' as _i513;
import '../core/network/domain/i_network_facade.dart' as _i305;
import '../core/network/infrastructure/network_facade.dart' as _i479;
import '../features/auth/application/account/account_bloc.dart' as _i27;
import '../features/auth/application/login/login_cubit.dart' as _i940;
import '../features/auth/application/register/register_cubit.dart' as _i26;
import '../features/auth/application/reset_password/reset_password_cubit.dart'
    as _i841;
import '../features/auth/auth.dart' as _i236;
import '../features/auth/domain/domain.dart' as _i968;
import '../features/auth/infrastructure/auth_facade.dart' as _i790;
import '../features/auth/infrastructure/datasources/auth_local_datasource.dart'
    as _i882;
import '../features/bible/application/bible/bible_bloc.dart' as _i558;
import '../features/bible/application/scripture_picker/scripture_picker_cubit.dart'
    as _i529;
import '../features/bible/application/translations/translations_cubit.dart'
    as _i478;
import '../features/bible/application/verses/verses_cubit.dart' as _i241;
import '../features/bible/domain/domain.dart' as _i720;
import '../features/bible/infrastructure/bible_facade.dart' as _i442;
import '../features/bible/infrastructure/datasources/datasources.dart' as _i150;
import '../features/bible/infrastructure/datasources/local/bible_local_datasource.dart'
    as _i664;
import '../features/broadcast/application/broadcast/broadcast_bloc.dart'
    as _i659;
import '../features/broadcast/application/broadcast_form/broadcast_form_cubit.dart'
    as _i866;
import '../features/broadcast/application/live_broadcasts/live_broadcasts_bloc.dart'
    as _i458;
import '../features/broadcast/application/live_participants/live_participants_bloc.dart'
    as _i505;
import '../features/broadcast/application/recently_live/recently_live_cubit.dart'
    as _i254;
import '../features/broadcast/application/stream/stream_bloc.dart' as _i241;
import '../features/broadcast/application/timer/timer_cubit.dart' as _i693;
import '../features/broadcast/broadcast.dart' as _i625;
import '../features/broadcast/domain/domain.dart' as _i923;
import '../features/broadcast/infrastructure/broadcast_facade.dart' as _i1031;
import '../features/chat/application/chat_bloc.dart' as _i913;
import '../features/discover/application/all/d_all_cubit.dart' as _i313;
import '../features/discover/application/filter/filter_bloc.dart' as _i212;
import '../features/discover/application/now_live/d_now_live_cubit.dart'
    as _i971;
import '../features/discover/application/recently_live/d_recently_live_cubit.dart'
    as _i908;
import '../features/discover/application/search/search_bloc.dart' as _i1051;
import '../features/discover/discover.dart' as _i515;
import '../features/discover/infrastructure/discover_facade.dart' as _i115;
import '../features/features.dart' as _i1009;
import '../features/notes/application/folder/folder_cubit.dart' as _i880;
import '../features/notes/application/folder_form/folder_form_cubit.dart'
    as _i904;
import '../features/notes/application/folder_list/folder_list_bloc.dart'
    as _i858;
import '../features/notes/application/note_form/note_form_cubit.dart' as _i987;
import '../features/notes/application/notes/notes_bloc.dart' as _i404;
import '../features/notes/domain/domain.dart' as _i365;
import '../features/notes/infrastructure/datasources/note_local_datasource.dart'
    as _i933;
import '../features/notes/infrastructure/note_facade.dart' as _i176;
import '../features/notes/notes.dart' as _i1042;
import '../features/notifications/domain/i_notification_facade.dart' as _i168;
import '../features/notifications/infrastructure/datasources/notification_remote_datasource.dart'
    as _i589;
import '../features/notifications/infrastructure/mapper/notifications_mapper.dart'
    as _i236;
import '../features/notifications/infrastructure/notification_facade.dart'
    as _i734;
import '../features/profile/application/my_profile/my_profile_cubit.dart'
    as _i1025;
import '../features/profile/application/others_profile/others_profile_cubit.dart'
    as _i948;
import '../features/profile/application/profile_form/profile_form_cubit.dart'
    as _i547;
import '../features/profile/domain/domain.dart' as _i74;
import '../features/profile/infrastructure/datasources/profile_local_datasource.dart'
    as _i517;
import '../features/profile/infrastructure/datasources/profile_remote_datasource.dart'
    as _i212;
import '../features/profile/infrastructure/mapper/profile_mapper.dart' as _i865;
import '../features/profile/infrastructure/profile_facade.dart' as _i920;
import '../features/settings/application/onboarding/onboarding_cubit.dart'
    as _i598;
import '../features/settings/infrastructure/datasources/settings_local_datasource.dart'
    as _i385;
import '../features/settings/infrastructure/settings_facade.dart' as _i838;
import '../features/settings/settings.dart' as _i709;
import '../services/jwt_service.dart' as _i431;
import '../services/live_kit/live_kit_service.dart' as _i691;
import '../services/media_service.dart' as _i586;
import '../services/meno/meno_bloc.dart' as _i336;
import '../services/network_service.dart' as _i463;
import '../services/notification_service.dart' as _i941;
import '../services/objectbox_service.dart' as _i116;
import '../services/permissions_service.dart' as _i179;
import '../services/secure_storage_service.dart' as _i535;
import '../services/services.dart' as _i264;
import '../services/socket/socket_service.dart' as _i717;
import '../shared/session/cubit/session_cubit.dart' as _i607;
import '../shared/session/session_context.dart' as _i320;
import '../shared/shared.dart' as _i44;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    await gh.factoryAsync<_i116.ObjectBoxService>(
      () => registerModule.obj,
      preResolve: true,
    );
    await gh.factoryAsync<_i179.PermissionsService>(
      () {
        final i = _i179.PermissionsService();
        return i.checkPermissions().then((_) => i);
      },
      preResolve: true,
    );
    gh.singleton<_i236.NotificationsMapper>(() => _i236.NotificationsMapper());
    gh.singleton<_i865.ProfileMapper>(() => _i865.ProfileMapper());
    gh.lazySingleton<_i1009.AuthRemoteDatasource>(
        () => registerModule.authRemoteDatasource);
    gh.lazySingleton<_i1009.BroadcastRemoteDatasource>(
        () => registerModule.broadcastRemoteDatasource);
    gh.lazySingleton<_i1009.DiscoverRemoteDatasource>(
        () => registerModule.discoverRemoteDatasource);
    gh.lazySingleton<_i1009.NotificationRemoteDatasource>(
        () => registerModule.notificationRemoteDatasource);
    gh.lazySingleton<_i1009.NoteRemoteDatasource>(
        () => registerModule.noteRemoteDatasource);
    gh.lazySingleton<_i1009.BibleRemoteDatasource>(
        () => registerModule.bibleRemoteDatasource);
    gh.lazySingleton<_i1009.ChatRemoteDatasource>(
        () => registerModule.chatRemoteDatasource);
    gh.lazySingleton<_i973.InternetConnectionChecker>(
        () => registerModule.internetChecker);
    gh.lazySingleton<_i183.ImagePicker>(() => registerModule.imagePicker);
    gh.lazySingleton<_i1009.ProfileRemoteDatasource>(
        () => registerModule.profileRemoteDatasource);
    gh.lazySingleton<_i892.FirebaseMessaging>(() => registerModule.fcm);
    gh.lazySingleton<_i163.FlutterLocalNotificationsPlugin>(
        () => registerModule.localNotifications);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => registerModule.secureStorage);
    gh.lazySingleton<_i693.TimerCubit>(() => _i693.TimerCubit());
    gh.lazySingleton<_i431.JWTService>(() => _i431.JWTService());
    gh.lazySingleton<_i691.LiveKitService>(() => _i691.LiveKitService());
    gh.lazySingleton<_i535.SecureStorageService>(
        () => _i535.SecureStorageService());
    gh.factory<_i933.NoteLocalDatasource>(
        () => _i933.NoteLocalDatasource(pref: gh<_i460.SharedPreferences>()));
    gh.factory<_i664.BibleLocalDatasource>(() =>
        _i664.BibleLocalDatasource(objectBox: gh<_i116.ObjectBoxService>()));
    await gh.factoryAsync<_i941.NotificationService>(
      () {
        final i = _i941.NotificationService(
          firebaseMessaging: gh<_i892.FirebaseMessaging>(),
          storageService: gh<_i535.SecureStorageService>(),
        );
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.factory<_i463.NetworkService>(
        () => _i463.NetworkService(gh<_i973.InternetConnectionChecker>()));
    gh.factory<_i515.IDiscoverFacade>(() => _i115.DiscoverFacade(
          remote: gh<_i515.DiscoverRemoteDatasource>(),
          network: gh<_i463.NetworkService>(),
        ));
    gh.factory<_i882.AuthLocalDatasource>(() =>
        _i882.AuthLocalDatasource(storage: gh<_i535.SecureStorageService>()));
    gh.factory<_i517.ProfileLocalDatasource>(() => _i517.ProfileLocalDatasource(
        storage: gh<_i535.SecureStorageService>()));
    gh.lazySingleton<_i305.INetworkFacade>(() => _i479.NetworkFacade(
        connectivity: gh<_i973.InternetConnectionChecker>()));
    gh.lazySingleton<_i586.MediaService>(
        () => _i586.MediaService(gh<_i183.ImagePicker>()));
    gh.lazySingleton<_i513.NetworkCubit>(
        () => _i513.NetworkCubit(facade: gh<_i305.INetworkFacade>()));
    gh.factory<_i385.SettingsLocalDatasource>(() =>
        _i385.SettingsLocalDatasource(
            preferences: gh<_i460.SharedPreferences>()));
    gh.factory<_i625.IBroadcastFacade>(() => _i1031.BroadcastFacade(
          remote: gh<_i625.BroadcastRemoteDatasource>(),
          network: gh<_i264.NetworkService>(),
        ));
    gh.lazySingleton<_i254.RecentlyLiveCubit>(
        () => _i254.RecentlyLiveCubit(facade: gh<_i923.IBroadcastFacade>()));
    gh.lazySingleton<_i168.INotificationFacade>(() => _i734.NotificationFacade(
          remoteDatasource: gh<_i589.NotificationRemoteDatasource>(),
          networkService: gh<_i463.NetworkService>(),
        ));
    gh.factory<_i709.ISettingsFacade>(
        () => _i838.SettingsFacade(local: gh<_i709.SettingsLocalDatasource>()));
    gh.factory<_i1042.INoteFacade>(() => _i176.NoteFacade(
          network: gh<_i264.NetworkService>(),
          local: gh<_i1042.NoteLocalDatasource>(),
          remote: gh<_i1042.NoteRemoteDatasource>(),
        ));
    await gh.factoryAsync<_i720.IBibleFacade>(
      () {
        final i = _i442.BibleFacade(
          local: gh<_i150.BibleLocalDatasource>(),
          remote: gh<_i150.BibleRemoteDatasource>(),
          network: gh<_i463.NetworkService>(),
        );
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    await gh.factoryAsync<_i236.IAuthFacade>(
      () {
        final i = _i790.AuthFacade(
          remoteDatasource: gh<_i236.AuthRemoteDatasource>(),
          localDatasource: gh<_i236.AuthLocalDatasource>(),
          networkService: gh<_i264.NetworkService>(),
          jwtService: gh<_i264.JWTService>(),
        );
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i313.DAllCubit>(
        () => _i313.DAllCubit(facade: gh<_i515.IDiscoverFacade>()));
    gh.lazySingleton<_i212.FilterBloc>(
        () => _i212.FilterBloc(facade: gh<_i515.IDiscoverFacade>()));
    gh.lazySingleton<_i971.DNowLiveCubit>(
        () => _i971.DNowLiveCubit(facade: gh<_i515.IDiscoverFacade>()));
    gh.lazySingleton<_i908.DRecentlyLiveCubit>(
        () => _i908.DRecentlyLiveCubit(facade: gh<_i515.IDiscoverFacade>()));
    gh.lazySingleton<_i1051.SearchBloc>(
        () => _i1051.SearchBloc(facade: gh<_i515.IDiscoverFacade>()));
    gh.factory<_i558.BibleBloc>(
        () => _i558.BibleBloc(facade: gh<_i720.IBibleFacade>()));
    gh.factory<_i529.ScripturePickerCubit>(
        () => _i529.ScripturePickerCubit(facade: gh<_i720.IBibleFacade>()));
    gh.factory<_i478.TranslationsCubit>(
        () => _i478.TranslationsCubit(facade: gh<_i720.IBibleFacade>()));
    gh.factory<_i241.VersesCubit>(
        () => _i241.VersesCubit(facade: gh<_i720.IBibleFacade>()));
    gh.factoryParam<_i987.NoteFormCubit, _i365.Note?, dynamic>((
      initialNote,
      _,
    ) =>
        _i987.NoteFormCubit(
          facade: gh<_i365.INoteFacade>(),
          initialNote: initialNote,
        ));
    gh.lazySingleton<_i858.FolderListBloc>(
        () => _i858.FolderListBloc(facade: gh<_i1042.INoteFacade>()));
    gh.lazySingleton<_i404.NotesBloc>(
        () => _i404.NotesBloc(facade: gh<_i1042.INoteFacade>()));
    gh.lazySingleton<_i74.IProfileFacade>(() => _i920.ProfileFacade(
          remote: gh<_i212.ProfileRemoteDatasource>(),
          local: gh<_i517.ProfileLocalDatasource>(),
          network: gh<_i463.NetworkService>(),
        ));
    gh.lazySingleton<_i547.ProfileFormCubit>(() => _i547.ProfileFormCubit(
          facade: gh<_i74.IProfileFacade>(),
          media: gh<_i586.MediaService>(),
        ));
    gh.lazySingleton<_i598.OnboardingCubit>(
        () => _i598.OnboardingCubit(facade: gh<_i709.ISettingsFacade>()));
    gh.lazySingleton<_i866.BroadcastFormCubit>(() => _i866.BroadcastFormCubit(
          facade: gh<_i625.IBroadcastFacade>(),
          mediaService: gh<_i586.MediaService>(),
        ));
    gh.factory<_i44.ISessionContext>(() => _i320.SessionContext(
          authFacade: gh<_i236.IAuthFacade>(),
          settingsFacade: gh<_i709.ISettingsFacade>(),
        ));
    gh.lazySingleton<_i904.FolderFormCubit>(
        () => _i904.FolderFormCubit(facade: gh<_i365.INoteFacade>()));
    gh.factoryParam<_i880.FolderCubit, _i365.Folder, dynamic>((
      folder,
      _,
    ) =>
        _i880.FolderCubit(
          facade: gh<_i365.INoteFacade>(),
          folder: folder,
        ));
    await gh.factoryAsync<_i717.SocketService>(
      () {
        final i = _i717.SocketService(facade: gh<_i1009.IAuthFacade>());
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i27.AccountBloc>(
        () => _i27.AccountBloc(facade: gh<_i236.IAuthFacade>()));
    gh.lazySingleton<_i26.RegisterCubit>(
        () => _i26.RegisterCubit(facade: gh<_i236.IAuthFacade>()));
    gh.lazySingleton<_i841.ResetPasswordCubit>(
        () => _i841.ResetPasswordCubit(facade: gh<_i968.IAuthFacade>()));
    gh.factory<_i1025.MyProfileCubit>(
        () => _i1025.MyProfileCubit(facade: gh<_i1009.IProfileFacade>()));
    gh.factory<_i948.OthersProfileCubit>(
        () => _i948.OthersProfileCubit(facade: gh<_i1009.IProfileFacade>()));
    gh.lazySingleton<_i940.LoginCubit>(() => _i940.LoginCubit(
          facade: gh<_i236.IAuthFacade>(),
          settingsFacade: gh<_i709.ISettingsFacade>(),
        ));
    await gh.factoryAsync<_i607.SessionCubit>(
      () {
        final i = _i607.SessionCubit(session: gh<_i44.ISessionContext>());
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    gh.factoryParam<_i659.BroadcastBloc, _i1009.Broadcast, dynamic>((
      broadcast,
      _,
    ) =>
        _i659.BroadcastBloc(
          broadcast: broadcast,
          facade: gh<_i1009.IBroadcastFacade>(),
          liveKit: gh<_i264.LiveKitService>(),
          socket: gh<_i264.SocketService>(),
        ));
    gh.lazySingleton<_i505.LiveParticipantsBloc>(
        () => _i505.LiveParticipantsBloc(
              socket: gh<_i264.SocketService>(),
              facade: gh<_i625.IBroadcastFacade>(),
            ));
    gh.factory<_i336.MenoBloc>(() => _i336.MenoBloc(
          liveKit: gh<_i264.LiveKitService>(),
          socket: gh<_i264.SocketService>(),
        ));
    gh.lazySingleton<_i458.LiveBroadcastsBloc>(() => _i458.LiveBroadcastsBloc(
          facade: gh<_i625.IBroadcastFacade>(),
          socket: gh<_i264.SocketService>(),
        ));
    gh.lazySingleton<_i913.ChatBloc>(() => _i913.ChatBloc(
          session: gh<_i1014.ISessionContext>(),
          socket: gh<_i264.SocketService>(),
        ));
    gh.factory<_i241.StreamBloc>(() => _i241.StreamBloc(
          facade: gh<_i1009.IBroadcastFacade>(),
          liveKit: gh<_i264.LiveKitService>(),
          socket: gh<_i264.SocketService>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
