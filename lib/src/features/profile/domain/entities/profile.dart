import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/auth/domain/domain.dart';
import 'package:meno_fe_v1/src/features/profile/domain/entities/user_stats.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'profile.freezed.dart';

@freezed
class Profile with _$Profile {
  factory Profile({
    required UserID id,
    required SingleLineString fullName,
    Bio? bio,
    String? imageUrl,
    UserStats? stats,
    bool? isSubscribedToUser,
    bool? verified,
  }) = _Profile;

  factory Profile.empty() => Profile(id: '', fullName: SingleLineString(''));
}
