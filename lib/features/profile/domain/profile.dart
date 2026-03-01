import 'package:equatable/equatable.dart';
import 'package:meno/features/profile/domain/user_stats.dart';
import 'package:meno/shared/domain/domain.dart';

final class Profile with EquatableMixin {
  const Profile({
    required this.id,
    required this.fullName,
    this.bio,
    this.stats,
    this.image,
    this.role,
    this.numberOfBroadcasts = 0,
    this.numberOfSubscribers = 0,
    this.numberOfSubscriptions = 0,
    this.isSubscribedToUser = false,
    this.subscribed = false,
  });

  factory Profile.fromUserEntity(User user) {
    return Profile(
      id: user.id,
      fullName: user.fullName,
      bio: user.bio,
      role: user.role,
      image: user.image,
    );
  }

  final Id id;
  final SingleLineString fullName;
  final MultiLineString? bio;
  final UserStats? stats;
  final ImageInput? image;
  final UserRole? role;
  final int numberOfBroadcasts;
  final int numberOfSubscribers;
  final int numberOfSubscriptions;
  final bool isSubscribedToUser;
  final bool subscribed;

  Profile copyWith({
    Id? id,
    SingleLineString? fullName,
    MultiLineString? bio,
    UserStats? stats,
    ImageInput? image,
    UserRole? role,
    bool? isSubscribedToUser,
    int? numberOfBroadcasts,
    int? numberOfSubscribers,
    int? numberOfSubscriptions,
    bool? subscribed,
  }) {
    return Profile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      bio: bio ?? this.bio,
      stats: stats ?? this.stats,
      image: image ?? this.image,
      role: role ?? this.role,
      isSubscribedToUser: isSubscribedToUser ?? this.isSubscribedToUser,
      numberOfBroadcasts: numberOfBroadcasts ?? this.numberOfBroadcasts,
      numberOfSubscribers: numberOfSubscribers ?? this.numberOfSubscribers,
      numberOfSubscriptions:
          numberOfSubscriptions ?? this.numberOfSubscriptions,
      subscribed: subscribed ?? this.subscribed,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    id,
    fullName,
    bio,
    stats,
    image,
    role,
    isSubscribedToUser,
    numberOfBroadcasts,
    numberOfSubscribers,
    numberOfSubscriptions,
    subscribed,
  ];
}

extension ProfileX on Profile {
  Profile get stripped {
    return Profile(
      id: id,
      fullName: fullName,
      bio: bio,
      image: image,
      stats: stats,
    );
  }
}

final fakeProfile = Profile(
  id: Id.empty,
  fullName: SingleLineString('New Birth Group'),
  bio: MultiLineString(
    '''This is a group that is committed to the growth of those that have been re-birthed in Christ. The vision of this group is to bring to light the possibilities of the New Creation in Christ via the teaching of the word, prayer-- equipping each member for the work of ministry, that each may walk worthy of the Lord in all things.''',
  ),
  stats: const UserStats(broadcasts: 14, subscribers: 300, subscriptions: 15),
);
