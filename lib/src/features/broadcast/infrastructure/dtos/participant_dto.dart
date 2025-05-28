import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/domain.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

part 'participant_dto.g.dart';

@JsonSerializable()
class ParticipantDto with EquatableMixin {
  const ParticipantDto({
    required this.id,
    required this.fullName,
    this.bio,
    this.imageUrl,
    this.broadcastId,
    this.role,
    this.numberOfListeners,
    this.isHostDisconnected,
    this.joinedAt,
    this.disconnectedAt,
  });

  factory ParticipantDto.fromJson(Map<String, dynamic> json) =>
      _$ParticipantDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantDtoToJson(this);

  final String id;
  final String fullName;
  final String? bio;
  final String? imageUrl;
  final String? broadcastId;
  final ParticipantRole? role;
  final int? numberOfListeners;
  final bool? isHostDisconnected;
  final DateTime? joinedAt;
  final DateTime? disconnectedAt;

  @override
  List<Object?> get props => [
        id,
        fullName,
        bio,
        imageUrl,
        broadcastId,
        role,
        numberOfListeners,
        isHostDisconnected,
        joinedAt,
        disconnectedAt,
      ];

  @override
  bool? get stringify => true;

  /// Overrides the equality operator to compare only based on the 'id'.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    // Ensure the runtime type is the same and then compare the 'id'
    return other is ParticipantDto && other.id == id;
  }

  /// Overrides the hashCode to be consistent with the custom '==' operator,
  /// using only the 'id' for hashing.
  @override
  int get hashCode => id.hashCode;
}

extension ParticipantToDomainX on ParticipantDto {
  Participant get toDomain {
    return Participant(
      id: ID.fromString(id),
      fullName: SingleLineString(fullName),
      bio: bio == null ? null : MultiLineString(bio!),
      imageUrl: imageUrl,
      broadcastId: broadcastId == null ? null : ID.fromString(broadcastId!),
      role: role,
      numberOfListeners: numberOfListeners,
      isHostDisconnected: isHostDisconnected,
      joinedAt: joinedAt,
      disconnectedAt: disconnectedAt,
    );
  }
}

extension ParticipantToDtoX on Participant {
  ParticipantDto get toDto {
    return ParticipantDto(
      id: id.getOrCrash(),
      fullName: fullName.getOrCrash(),
      bio: bio?.getOrNull(),
      imageUrl: imageUrl,
      broadcastId: broadcastId?.getOrNull(),
      role: role,
      numberOfListeners: numberOfListeners,
      isHostDisconnected: isHostDisconnected,
      joinedAt: joinedAt,
      disconnectedAt: disconnectedAt,
    );
  }
}
