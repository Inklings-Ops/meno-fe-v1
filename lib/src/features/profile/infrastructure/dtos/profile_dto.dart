import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/auth/domain/domain.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

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
    int? numberOfBroadcasts,
    int? numberOfSubscribers,
    int? numberOfSubscriptions,
    bool? subscribed,
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
      fullName: SingleLineString(fullName),
      imageUrl: imageUrl,
      bio: bio == null ? null : Bio(bio!),
      isSubscribedToUser: isSubscribedToUser,
      stats: UserStats(
        broadcasts: stats?.broadcasts,
        subscribers: stats?.subscribers,
        subscriptions: stats?.subscriptions,
      ),
      verified: verified,
      numberOfBroadcasts: numberOfBroadcasts,
      numberOfSubscribers: numberOfSubscribers,
      numberOfSubscriptions: numberOfSubscriptions,
      subscribed: subscribed,
    );
  }
}

extension ProfileToDto on Profile {
  ProfileDto get toDto {
    return ProfileDto(
      id: id,
      fullName: fullName.getOr(),
      imageUrl: imageUrl,
      bio: bio?.getOr(),
      isSubscribedToUser: isSubscribedToUser,
      stats: UserStatsDto(
        broadcasts: stats?.broadcasts,
        subscribers: stats?.subscribers,
        subscriptions: stats?.subscriptions,
      ),
      verified: verified,
      numberOfBroadcasts: numberOfBroadcasts,
      numberOfSubscribers: numberOfSubscribers,
      numberOfSubscriptions: numberOfSubscriptions,
      subscribed: subscribed,
    );
  }
}
