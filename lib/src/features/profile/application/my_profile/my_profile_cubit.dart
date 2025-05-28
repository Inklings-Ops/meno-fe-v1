import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  MyProfileCubit({
    required IProfileFacade facade,
    required ISessionContext session,
  })  : _facade = facade,
        _session = session,
        super(const MyProfileInitial()) {
    _subscription = _session.userChanges.listen((_) async => fetch());
  }

  final IProfileFacade _facade;
  final ISessionContext _session;

  late final StreamSubscription<UserCredential?> _subscription;

  Future<void> fetch() async {
    emit(const MyProfileLoadInProgress());
    final myUserId = _session.credential?.user.id;
    if (myUserId == null) {
      emit(const MyProfileLoadFailure(NoProfileFoundException()));
    } else {
      final fOrP = await _facade.getProfile(myUserId);
      emit(fOrP.fold(MyProfileLoadFailure.new, MyProfileLoadSuccess.new));
    }
  }

  void optimisticallyUpdate(Profile p) => emit(MyProfileLoadSuccess(p));

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
