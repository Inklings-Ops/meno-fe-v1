import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'profile_dto.g.dart';

@JsonSerializable()
final class ProfileDto with EquatableMixin {
  const ProfileDto({
    required this.id,
    required this.fullName,
    this.bio,
    this.stats,
    this.imageUrl,
    this.role,
    this.isSubscribedToUser,
    this.numberOfBroadcasts,
    this.numberOfSubscribers,
    this.numberOfSubscriptions,
    this.subscribed,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDtoToJson(this);

  final String id;

  final String fullName;

  final String? bio;

  @JsonKey(name: '_count')
  final UserStatsDto? stats;

  final String? imageUrl;

  final AuthRole? role;

  final bool? isSubscribedToUser;

  final int? numberOfBroadcasts;

  final int? numberOfSubscribers;

  final int? numberOfSubscriptions;

  final bool? subscribed;

  @override
  List<Object?> get props => [
    id,
    fullName,
    bio,
    stats,
    imageUrl,
    role,
    isSubscribedToUser,
    numberOfBroadcasts,
    numberOfSubscribers,
    numberOfSubscriptions,
    subscribed,
  ];

  @override
  bool get stringify => true;
}

extension ProfileToDto on Profile {
  ProfileDto get toDto {
    return ProfileDto(
      id: id.getOrElse(() => ''),
      fullName: fullName.getOrElse(() => ''),
      bio: bio?.getOrElse(() => ''),
      stats: stats?.toDto,
      imageUrl: imageUrl,
      isSubscribedToUser: isSubscribedToUser,
      numberOfBroadcasts: numberOfBroadcasts,
      numberOfSubscribers: numberOfSubscribers,
      numberOfSubscriptions: numberOfSubscriptions,
      role: role,
      subscribed: subscribed,
    );
  }
}

extension ProfileToDomain on ProfileDto {
  Profile get toDomain {
    return Profile(
      id: ID.fromString(id),
      fullName: SingleLineString(fullName),
      bio: bio == null ? null : MultiLineString(bio!),
      stats: stats?.toDomain,
      imageUrl: imageUrl,
      isSubscribedToUser: isSubscribedToUser,
      numberOfBroadcasts: numberOfBroadcasts,
      numberOfSubscribers: numberOfSubscribers,
      numberOfSubscriptions: numberOfSubscriptions,
      role: role,
      subscribed: subscribed,
    );
  }

  ProfileDto get stripped {
    return ProfileDto(
      id: id,
      fullName: fullName,
      bio: bio,
      imageUrl: imageUrl,
      stats: stats,
    );
  }
}
