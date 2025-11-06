import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_domain/meno_domain.dart';
import 'package:meno_domain/src/converters/converters.dart';

part 'broadcast.freezed.dart';

part 'broadcast.g.dart';

/// Represents a live or scheduled audio broadcast session.
///
/// This class serves as the primary entity for a broadcast,
/// containing all its details, status, and related creator info.
@freezed
abstract class Broadcast with _$Broadcast {
  /// Creates a Broadcast instance.
  /// This factory is the main constructor for the class.
  const factory Broadcast({
    /// The unique identifier for the broadcast.
    @IdConverter() required Id id,

    /// The title of the broadcast.
    @SingleLineStringConverter() required SingleLineString title,

    /// The detailed description of the broadcast.
    @MultiLineStringConverter() required MultiLineString description,

    /// The current status of the broadcast (e.g., active, inactive).
    /// Defaults to [BroadcastStatus.inactive] if not provided.
    @Default(BroadcastStatus.inactive) BroadcastStatus status,

    /// The authentication token required to join the broadcast
    /// room (e.g., LiveKit).
    String? broadcastToken,

    /// The unique ID of the broadcast's creator.
    @IdConverter() Id? creatorId,

    /// The embedded participant object for the creator.
    /// This may be null if only the ID is provided (e.g., in a list).
    Participant? creator,

    /// Denormalized full name of the creator.
    @SingleLineStringConverter() SingleLineString? fullName,

    /// The cover image URL for the broadcast.
    String? imageUrl,

    /// The scheduled start time of the broadcast.
    DateTime? startTime,

    /// The time the broadcast actually ended.
    DateTime? endTime,

    /// The creation timestamp.
    DateTime? createdAt,

    /// Flag indicating if the broadcast is deleted.
    /// Type is [dynamic] for legacy compatibility.
    dynamic deleted,

    /// The number of listeners currently in the room.
    int? liveListeners,

    /// The total number of unique listeners that joined the broadcast.
    int? totalListeners,

    /// Denormalized full name of the creator.
    @SingleLineStringConverter() SingleLineString? creatorFullName,

    /// Denormalized bio of the creator.
    @MultiLineStringConverter() MultiLineString? creatorBio,

    /// Denormalized avatar URL of the creator.
    String? creatorImageUrl,

    /// The ID of the cover image (if one was uploaded via the API).
    String? imageId,

    /// The timezone the broadcast was scheduled in (e.g., "Africa/Lagos").
    String? timeZone,
  }) = _Broadcast;

  /// Reconstructs a [Broadcast] instance from a JSON map.
  /// This factory points to the generated `_$BroadcastFromJson` constructor
  /// in the 'broadcast.g.dart' file.
  factory Broadcast.fromJson(Map<String, dynamic> json) =>
      _$BroadcastFromJson(json);
}

/// Provides helper methods and static values for the [Broadcast] class.
extension BroadcastX on Broadcast {
  /// A static representation of an empty/uninitialized broadcast.
  /// Used for default states or placeholders.
  static Broadcast get empty => Broadcast(
    id: Id.empty,
    title: SingleLineString.empty,
    description: MultiLineString.empty,
  );

  /// Returns true if the broadcast is the empty/uninitialized instance.
  bool get isEmpty => this == BroadcastX.empty;

  /// Returns true if the broadcast is not the empty/uninitialized instance.
  bool get isNotEmpty => this != BroadcastX.empty;

  /// A convenience getter to check if the broadcast is currently live.
  bool get isLive => status == BroadcastStatus.active;
}
