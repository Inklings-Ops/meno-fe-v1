import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

part 'others_profile_cubit.freezed.dart';
part 'others_profile_state.dart';

@Injectable()
class OthersProfileCubit extends HydratedCubit<OthersProfileState> {
  OthersProfileCubit({required IProfileFacade facade})
      : _facade = facade,
        super(const OthersProfileLoadInProgress());

  final IProfileFacade _facade;

  Future<void> fetch(String id) async {
    emit(const OthersProfileLoadInProgress());
    final failureOrProfile = await _facade.getProfile(id);
    return failureOrProfile.fold(
      (exception) => emit(OthersProfileFailed(exception)),
      (profile) => emit(OthersProfileLoaded(profile)),
    );
  }

  @override
  OthersProfileState? fromJson(Map<String, dynamic> json) {
    if (state is OthersProfileLoaded) {
      final profileDto = ProfileDto.fromJson(
        json['profile'] as Map<String, dynamic>,
      );
      return OthersProfileLoaded(profileDto.toDomain);
    }
    return state;
  }

  @override
  Map<String, dynamic>? toJson(OthersProfileState state) {
    if (state is OthersProfileLoaded) {
      return {'profile': state.profile.toDto.toJson()};
    }
    return null;
  }
}
