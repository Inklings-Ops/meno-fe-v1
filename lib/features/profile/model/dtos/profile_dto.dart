import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/model/entities/user.dart';
import 'package:meno/features/profile/model/_model.dart';

final class ProfileDto {
  const ProfileDto({
    required this.id,
    required this.fullName,
    this.bio,
    this.stats,
    this.imageUrl,
    this.role,
    this.numberOfBroadcasts = 0,
    this.numberOfSubscribers = 0,
    this.numberOfSubscriptions = 0,
    this.isSubscribedToUser = false,
    this.subscribed = false,
  });

  factory ProfileDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid profile JSON');
    }

    return ProfileDto(
      id: json[_kId] as String,
      fullName: json[_kFullName] as String,
      bio: json[_kBio] as String?,
      stats: json[_kStats] != null
          ? UserStatsDto.fromJson(json[_kStats])
          : null,
      imageUrl: json[_kImageUrl] as String?,
      role: json[_kRole] != null ? UserRole.fromJson(json[_kRole]) : null,
      numberOfBroadcasts: (json[_kNumberOfBroadcasts] as num?)?.toInt() ?? 0,
      numberOfSubscribers: (json[_kNumberOfSubscribers] as num?)?.toInt() ?? 0,
      numberOfSubscriptions:
          (json[_kNumberOfSubscriptions] as num?)?.toInt() ?? 0,
      isSubscribedToUser: json[_kIsSubscribedToUser] as bool? ?? false,
      subscribed: json[_kSubscribed] as bool? ?? false,
    );
  }

  final String id;
  final String fullName;
  final String? bio;
  final UserStatsDto? stats;
  final String? imageUrl;
  final UserRole? role;
  final int numberOfBroadcasts;
  final int numberOfSubscribers;
  final int numberOfSubscriptions;
  final bool isSubscribedToUser;
  final bool subscribed;

  static const String _kId = 'id';
  static const String _kFullName = 'fullName';
  static const String _kBio = 'bio';
  static const String _kStats = '_count';
  static const String _kImageUrl = 'imageUrl';
  static const String _kRole = 'role';
  static const String _kNumberOfBroadcasts = 'numberOfBroadcasts';
  static const String _kNumberOfSubscribers = 'numberOfSubscribers';
  static const String _kNumberOfSubscriptions = 'numberOfSubscriptions';
  static const String _kIsSubscribedToUser = 'isSubscribedToUser';
  static const String _kSubscribed = 'subscribed';

  Map<String, dynamic> toJson() => {
    _kId: id,
    _kFullName: fullName,
    _kBio: bio,
    _kStats: stats?.toJson(),
    _kImageUrl: imageUrl,
    _kRole: role?.value,
    _kNumberOfBroadcasts: numberOfBroadcasts,
    _kNumberOfSubscribers: numberOfSubscribers,
    _kNumberOfSubscriptions: numberOfSubscriptions,
    _kIsSubscribedToUser: isSubscribedToUser,
    _kSubscribed: subscribed,
  };
}

extension ProfileToDto on Profile {
  ProfileDto get toDto {
    return ProfileDto(
      id: id.getOrCrash(),
      fullName: fullName.getOrCrash(),
      bio: bio?.getOrNull(),
      stats: stats?.toDto,
      imageUrl: switch (image?.getOrNull()) {
        NetworkImageOrigin(:final url) => url,
        LocalImageOrigin(:final file) => file.path,
        _ => null,
      },
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
      id: Id.fromString(id),
      fullName: SingleLineString(fullName),
      bio: bio == null ? null : MultiLineString(bio!),
      stats: stats?.toDomain,
      image: imageUrl != null ? ImageInput.fromUrl(imageUrl) : null,
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
