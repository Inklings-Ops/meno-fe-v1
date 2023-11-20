import 'package:injectable/injectable.dart';

import '../../../auth/domain/domain.dart';
import '../../domain/domain.dart';
import '../infrastructure.dart';

/// A class for mapping between `UserCredentials` and `Profile` domain objects and `UserCredentialDto` and `Profile` DTOs.
@singleton
class ProfileMapper {
  /// Converts a `ProfileDto` DTO to a `Profile` domain object.
  Profile? toDomain(ProfileDto? dto) {
    if (dto == null) return null;
    return Profile(
      id: dto.id,
      fullName: IFullName(dto.fullName),
      bio: dto.bio != null ? IBio(dto.bio!) : null,
      verified: dto.verified,
      imageUrl: dto.imageUrl,
      isSubscribedToUser: dto.isSubscribedToUser,
      stats: UserStats(
        broadcasts: dto.stats?.broadcasts,
        subscriptions: dto.stats?.subscriptions,
        subscribers: dto.stats?.subscribers,
      ),
    );
  }

  /// Converts a `Profile` domain object to a `ProfileDto` DTO.
  ProfileDto? toDto(Profile? domain) {
    if (domain == null) return null;
    return ProfileDto(
      id: domain.id,
      fullName: domain.fullName.get()!,
      bio: domain.bio?.get(),
      verified: domain.verified,
      imageUrl: domain.imageUrl,
      isSubscribedToUser: domain.isSubscribedToUser,
      stats: UserStatsDto(
        broadcasts: domain.stats?.broadcasts,
        subscriptions: domain.stats?.subscriptions,
        subscribers: domain.stats?.subscribers,
      ),
    );
  }
}
