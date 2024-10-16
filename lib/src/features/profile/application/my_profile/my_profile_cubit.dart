import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

part 'my_profile_cubit.freezed.dart';
part 'my_profile_state.dart';

@Injectable()
class MyProfileCubit extends Cubit<MyProfileState> {
  MyProfileCubit({required IProfileFacade facade})
      : _facade = facade,
        super(const MyProfileState.loading());

  final IProfileFacade _facade;

  Future<void> fetch() async {
    final failureOrProfile = await _facade.getAuthProfile();
    return failureOrProfile.fold(
      (exception) => emit(MyProfileFailed(exception)),
      (profile) => emit(MyProfileLoaded(profile!)),
    );
  }
}
