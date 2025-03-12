import 'package:dartz/dartz.dart';
import 'package:meno_fe_v1/src/features/auth/domain/domain.dart';
import 'package:meno_fe_v1/src/features/profile/domain/domain.dart';

abstract class IProfileFacade {
  /// Retrieves the user's profile with the given [UserID]
  Future<Either<AuthException, Profile>> getProfile(UserID id);

  Future<Either<AuthException, Profile?>> getAuthProfile();

  /// Returns a list of user profiles that are subscribed to the 
  /// [subscriptionId]
  Future<Either<AuthException, SubscribersList>> getSubscribers({
    required String subscriptionId,
    String? include,
    String? keywords,
    int? page,
    int? size,
  });

  /// Returns list of users profiles the [subscriberId] is subscribed to
  Future<Either<AuthException, SubscribersList>> getSubscriptions({
    required String subscriberId,
    String? include,
    String? keywords,
    int? page,
    int? size,
  });

  Future<Either<AuthException, Unit>> subscribe(String userId);

  Future<Either<AuthException, Unit>> unsubscribe(String userId);
}
