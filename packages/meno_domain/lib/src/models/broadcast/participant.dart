import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_domain/meno_domain.dart';
import 'package:meno_domain/src/converters/converters.dart';

part 'participant.freezed.dart';

part 'participant.g.dart';

/// Represents a participant in a broadcast.
@freezed
abstract class Participant with _$Participant {
  const factory Participant({
    /// The unique identifier of the participant.
    @IdConverter() required Id id,

    /// The full name of the participant.
    @SingleLineStringConverter() required SingleLineString fullName,

    /// The biography of the participant.
    @MultiLineStringConverter() MultiLineString? bio,

    /// The profile picture of the participant.
    @ImageObjectConverter() ImageObject? imageUrl,

    /// The ID of the broadcast the participant is in.
    @IdConverter() Id? broadcastId,

    /// The role of the participant in the broadcast.
    ParticipantRole? role,

    /// The number of listeners in the broadcast (if the participant is a host).
    int? numberOfListeners,

    /// Whether the host is disconnected.
    bool? isHostDisconnected,

    /// The time the participant joined the broadcast.
    DateTime? joinedAt,

    /// The time the participant disconnected from the broadcast.
    DateTime? disconnectedAt,
  }) = _Participant;

  /// Creates a [Participant] from a JSON object.
  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);
}
