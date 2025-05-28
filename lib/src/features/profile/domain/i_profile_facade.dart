import 'package:dartz/dartz.dart';
import 'package:meno_fe_v1/src/core/core.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

abstract class IProfileFacade {
  /// Updates the [Profile] of the currently authenticated with the
  /// given fields:
  ///
  /// [SingleLineString] : Full name of the user
  ///
  /// [MultiLineString] : Biography of the user
  ///
  /// [ImageFile] : Image of the user
  ///
  Future<Either<ProfileException, Profile>> editProfile({
    required ID id,
    SingleLineString? fullName,
    MultiLineString? bio,
    ImageFile? image,
  });

  /// Gets the [Profile] that matches the give [id]
  ///
  Future<Either<ProfileException, Profile>> getProfile(ID id);

  Future<Either<ProfileException, PaginatedList<Profile?>>> getProfiles({
    /// Searches for users with a name that partially or fully match the
    /// keyword. Example: `John`
    ///
    String? keywords,

    /// Adds an extra field to each response indicating if the logged in
    /// user is subscribed to the user Example: `subscribed`
    ///
    /// Defaults to `subscribed`
    ///
    String include = 'subscribed',

    /// Sort by a specific user field
    /// Defaults to `fullName` of the profiles
    ///
    String sortBy = 'fullName',

    /// Order by a specific user field
    /// Examples:
    ///
    /// [OrderBy.ASC] which is the ascending order
    ///
    /// [OrderBy.DESC] which is the descending order
    ///
    OrderBy orderBy = OrderBy.ASC,

    /// Used for pagination.
    ///
    /// Defaults to `1` signifying the first page
    int page = 1,

    /// The number of items to be returned per `page`
    ///
    /// Used for pagination
    ///
    /// Defaults to `8`
    ///
    int size = 8,
  });

  /// Returns a list of [Profile]s that are subscribed to your account
  ///
  Future<Either<ProfileException, PaginatedList<Profile?>>> getSubscribers({
    /// The [Profile] or [User] id of the person you are subscribed to
    ///
    required ID subscriptionId,

    /// Adds an extra field to each response indicating if the logged in
    /// user is subscribed to the user Example: `subscribed`
    ///
    /// Defaults to `subscribed`
    ///
    String include = 'subscribed',

    /// Searches for users with a name that partially or fully match the
    /// keyword. Example: `John`
    ///
    String? keywords,

    /// Used for pagination.
    ///
    /// Defaults to `1` signifying the first page
    int page = 1,

    /// The number of items to be returned per `page`
    ///
    /// Used for pagination
    ///
    /// Defaults to `8`
    ///
    int size = 8,
  });

  /// Returns a list of [Profile]s your account is subscribed to
  ///
  Future<Either<ProfileException, PaginatedList<Profile?>>> getSubscriptions({
    /// The [Profile] or [User] id of the subscriber
    ///
    required ID subscriberId,

    /// Adds an extra field to each response indicating if the logged in
    /// user is subscribed to the user Example: `subscribed`
    ///
    /// Defaults to `subscribed`
    ///
    String include = 'subscribed',

    /// Searches for users with a name that partially or fully match the
    /// keyword. Example: `John`
    ///
    String? keywords,

    /// Used for pagination.
    ///
    /// Defaults to `1` signifying the first page
    int page = 1,

    /// The number of items to be returned per `page`
    ///
    /// Used for pagination
    ///
    /// Defaults to `8`
    ///
    int size = 8,
  });

  /// Subscribes to the [Profile] with the given [ID]: [id]
  ///
  Future<Either<ProfileException, Unit>> subscribe(ID id);

  /// Unsubscribes from the [Profile] with the given [ID]: [id]
  ///
  Future<Either<ProfileException, Unit>> unsubscribe(ID id);
}
