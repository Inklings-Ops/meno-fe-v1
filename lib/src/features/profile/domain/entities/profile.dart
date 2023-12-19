import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/domain/domain.dart';
import 'user_stats.dart';

part 'profile.freezed.dart';

@freezed
class Profile with _$Profile {
  factory Profile({
    required UserID id,
    required IFullName fullName,
    IBio? bio,
    String? imageUrl,
    UserStats? stats,
    bool? isSubscribedToUser,
    bool? verified,
  }) = _Profile;
}

