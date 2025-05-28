import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

final class Profile with EquatableMixin {
  const Profile({
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

  factory Profile.fake() => _fakeProfile;

  factory Profile.fromUserEntity(User user) {
    return Profile(
      id: user.id,
      fullName: user.fullName,
      bio: user.bio,
      role: user.role,
      imageUrl: user.imageUrl,
    );
  }

  final ID id;
  final SingleLineString fullName;
  final MultiLineString? bio;
  final UserStats? stats;
  final String? imageUrl;
  final AuthRole? role;
  final bool? isSubscribedToUser;
  final int? numberOfBroadcasts;
  final int? numberOfSubscribers;
  final int? numberOfSubscriptions;
  final bool? subscribed;

  Profile copyWith({
    ID? id,
    SingleLineString? fullName,
    MultiLineString? bio,
    UserStats? stats,
    String? imageUrl,
    AuthRole? role,
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
      imageUrl: imageUrl ?? this.imageUrl,
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
        imageUrl,
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
      imageUrl: imageUrl,
      stats: stats,
    );
  }
}

final _fakeProfile = Profile(
  id: ID.empty,
  fullName: SingleLineString('New Birth Group'),
  bio: MultiLineString(
    '''This is a group that is committed to the growth of those that have been re-birthed in Christ. The vision of this group is to bring to light the possibilities of the New Creation in Christ via the teaching of the word, prayer-- equipping each member for the work of ministry, that each may walk worthy of the Lord in all things.''',
  ),
  imageUrl: '',
  stats: const UserStats(
    broadcasts: 14,
    subscribers: 300,
    subscriptions: 15,
  ),
);
