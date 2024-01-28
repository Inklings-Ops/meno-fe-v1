import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../profile.dart';

part 'my_profile_bloc.freezed.dart';
part 'my_profile_event.dart';
part 'my_profile_state.dart';

@lazySingleton
class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  final IProfileFacade _facade;

  MyProfileBloc({required IProfileFacade facade})
      : _facade = facade,
        super(const MyProfileState.loading()) {
    on<_FetchProfileData>(_onFetch);

    add(const _FetchProfileData());
  }

  Future<void> _onFetch(event, emit) async {
    emit(const MyProfileState.loading());

    final result = await _facade.getAuthProfile();

    return result.fold(
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
