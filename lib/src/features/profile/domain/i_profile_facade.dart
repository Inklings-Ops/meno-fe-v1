import 'package:dartz/dartz.dart';
import 'package:meno_fe_v1/src/features/auth/domain/domain.dart';
import 'package:meno_fe_v1/src/features/profile/domain/domain.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

abstract class IProfileFacade {
  Future<Either<AuthException, Unit>> editProfile({
    SingleLineString? fullName,
    Bio? bio,
    Avatar? avatar,
  });

  /// Retrieves the user's profile with the given [UserID]
  Future<Either<AuthException, Profile>> getProfile(UserID id);

  Future<Either<AuthException, Profile?>> getAuthProfile();

  // Future<Either<AuthException, Unit>> subscribe(Uid<User> userId);

  // Future<Either<AuthException, Unit>> unsubscribe(Uid<User> userId);

  // Future<Option<int>> getSubscribers();
}
