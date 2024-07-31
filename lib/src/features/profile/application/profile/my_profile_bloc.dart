import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

import 'package:meno_fe_v1/src/features/profile/profile.dart';

part 'my_profile_bloc.freezed.dart';
part 'my_profile_event.dart';
part 'my_profile_state.dart';

@lazySingleton
class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  MyProfileBloc({required IProfileFacade facade})
      : _facade = facade,
        super(const MyProfileState.loading()) {
    on<_FetchProfileData>(_onFetch);
    add(const _FetchProfileData());
  }
  final IProfileFacade _facade;

  void init([String? id]) => add(MyProfileEvent.fetch(id));

  Future<void> _onFetch(
    _FetchProfileData event,
    Emitter<MyProfileState> emit,
  ) async {
    emit(const MyProfileState.loading());
    late Either<AuthException, Profile?> fOrS;
    if (event.id != null) {
      fOrS = await _facade.getProfile(event.id!);
    } else {
      fOrS = await _facade.getAuthProfile();
    }
    return fOrS.fold(
      (failure) => emit(const _Failure()),
      (success) => emit(_Success(success!)),
    );
  }
}

// final dio = MClients.dioClient(Env.menoApiUrl);
// final remote = ProfileRemoteDatasource(dio, baseUrl: Env.menoApiUrl);

// Future<Profile?> _getProfile(RootIsolateToken token, String id) async {
//   BackgroundIsolateBinaryMessenger.ensureInitialized(token);

//   try {
//     final result = await remote.getProfile(id);
//     final profile = result.data?.toDomain;
//     return profile;
//   } catch (e) {
//     throw Exception(e);
//   }
// }
