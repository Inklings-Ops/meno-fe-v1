import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/domain/domain.dart';
import '../../profile.dart';

part 'profile_dto.freezed.dart';
part 'profile_dto.g.dart';

@freezed
@JsonSerializable(
  createFactory: false,
  includeIfNull: false,
  explicitToJson: true,
)
class ProfileDto with _$ProfileDto {
  factory ProfileDto({
    required String id,
    required String fullName,
    String? bio,
    String? imageUrl,
    @JsonKey(name: '_count') UserStatsDto? stats,
    bool? isSubscribedToUser,
    bool? verified,
  }) = _ProfileDto;

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProfileDtoToJson(this);
}

extension ProfileDtoToDomain on ProfileDto {
  Profile get toDomain {
    return Profile(
      id: id,
      fullName: IFullName(fullName),
      imageUrl: imageUrl,
      bio: bio == null ? null : IBio(bio!),
      isSubscribedToUser: isSubscribedToUser,
      stats: UserStats(
        broadcasts: stats?.broadcasts,
        subscribers: stats?.subscribers,
        subscriptions: stats?.subscriptions,
      ),
      verified: verified,
    );
  }
}
