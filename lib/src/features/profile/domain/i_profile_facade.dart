import 'package:dartz/dartz.dart';

import '../../auth/domain/domain.dart';
import 'domain.dart';

abstract class IProfileFacade {
  Future<Either<AuthException, Unit>> editProfile({
    required UserID id,
    IFullName? fullName,
    IBio? bio,
    IAvatar? avatar,
  });

  /// Retrieves the user's profile with the given [UserID]
  Future<Either<AuthException, Profile>> getProfile(UserID id);

  Future<Either<AuthException, Profile?>> getAuthProfile();
}
