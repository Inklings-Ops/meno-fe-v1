import 'dart:async';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

part 'my_profile_cubit.freezed.dart';
part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  MyProfileCubit({
    required IProfileFacade facade,
    required ISessionContext session,
  })  : _facade = facade,
        _session = session,
        super(MyProfileLoaded(Profile.empty())) {
    _subscription = _session.userChanges.listen((_) async => fetch());
  }

  final IProfileFacade _facade;
  final ISessionContext _session;

  late final StreamSubscription<UserCredential?> _subscription;

  Future<void> fetch() async {
    emit(const MyProfileState.loading());
    final failureOrProfile = await _facade.getAuthProfile();
    return failureOrProfile.fold(
      (exception) => emit(MyProfileFailed(exception)),
      (profile) => emit(MyProfileLoaded(profile!)),
    );
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
