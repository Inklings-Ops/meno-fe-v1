import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

part 'others_profile_state.dart';

class OthersProfileCubit extends Cubit<OthersProfileState> {
  OthersProfileCubit({
    required IProfileFacade facade,
    required ID userId,
  })  : _facade = facade,
        _userId = userId,
        super(const OthersProfileInitial());

  final IProfileFacade _facade;
  final ID _userId;

  Future<void> fetch() async {
    emit(const OthersProfileLoadInProgress());
    final failureOrProfile = await _facade.getProfile(_userId);
    return emit(
      failureOrProfile.fold(
        OthersProfileLoadFailure.new,
        OthersProfileLoadSuccess.new,
      ),
    );
  }
}
