import 'package:dartz/dartz.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

import '../../auth/domain/domain.dart';
import 'domain.dart';

abstract class IProfileFacade {
  Future<Either<AuthException, Unit>> editProfile({
    SingleLineString? fullName,
    Bio? bio,
    Avatar? avatar,
  });

  /// Retrieves the user's profile with the given [UserID]
  Future<Either<AuthException, Profile?>> getProfile(UserID id);

  Future<Either<AuthException, Profile?>> getAuthProfile();
}
