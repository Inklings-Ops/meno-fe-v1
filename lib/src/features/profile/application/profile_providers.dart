// import 'dart:isolate';

// import 'package:flutter/services.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// import '../../../core/clients/m_clients.dart';
// import '../../../core/env/env.dart';
// import '../../../dependency_injector/injector.dart';
// import '../../auth/application/auth_old/auth_notifier.dart';
// import '../../auth/domain/domain.dart';
// import '../domain/domain.dart';
// import '../infrastructure/infrastructure.dart';
// import '../infrastructure/mapper/profile_mapper.dart';

// part 'profile_providers.g.dart';

// final dio = MClients.dioClient(Env.menoApiUrl);
// final remote = ProfileRemoteDatasource(dio, baseUrl: Env.menoApiUrl);

// Future<Profile?> _getProfile(RootIsolateToken token, String id) async {
//   BackgroundIsolateBinaryMessenger.ensureInitialized(token);

//   try {
//     final result = await remote.getProfile(id);
//     final Profile? profile = ProfileMapper().toDomain(result.data);
//     return profile;
//   } catch (e) {
//     throw Exception(e);
//   }
// }

// // @riverpod
// // Future<void> editProfile(EditProfileRef ref) async {
// //   const AsyncValue.loading();

// //   final id = ref.read(userProvider).id;
// //   final formState = ref.read(profileFormNotifierProvider);

// //   final result = await ref.read(profileFacadeProvider).editProfile(
// //         id: id,
// //         avatar: formState.avatar,
// //         bio: formState.bio,
// //         fullName: formState.fullName,
// //       );

// //   return result.fold(
// //     (l) => AsyncValue.error(l, StackTrace.current),
// //     (r) => AsyncValue.data(r),
// //   );
// // }

// @riverpod
// Future<Profile?> profile(ProfileRef ref, UserID id) async {
//   RootIsolateToken token = RootIsolateToken.instance!;
//   final result = await Isolate.run(() => _getProfile(token, id));
//   return result;
// }

// @riverpod
// Future<Profile?> myProfile(MyProfileRef ref) async {
//   RootIsolateToken token = RootIsolateToken.instance!;
//   final id = ref.read(userProvider).id;
//   final result = await Isolate.run(() => _getProfile(token, id));
//   return result;
// }

// @riverpod
// IProfileFacade profileFacade(ProfileFacadeRef ref) => di<IProfileFacade>();
