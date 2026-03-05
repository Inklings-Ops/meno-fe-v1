import 'package:equatable/equatable.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/features/broadcast/model/entities/entities.dart';

class ParticipantDto with EquatableMixin {
  const ParticipantDto({
    required this.id,
    required this.fullName,
    this.bio,
    this.imageUrl,
    this.broadcastId,
    this.role = ParticipantRole.unknown,
    this.numberOfListeners,
    this.isHostDisconnected,
    this.joinedAt,
    this.disconnectedAt,
  });

  factory ParticipantDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw FormatError<ParticipantDto>();
    return ParticipantDto(
      id: json[_kId] as String,
      fullName: json[_kFullName] as String,
      bio: json[_kBio] as String?,
      imageUrl: json[_kImageUrl] as String?,
      broadcastId: json[_kBroadcastId] as String?,
      role: json[_kRole] != null
          ? (json[_kRole] as String).toRole()
          : ParticipantRole.listener,
      numberOfListeners: (json[_kNumberOfListeners] as num?)?.toInt(),
      isHostDisconnected: json[_kIsHostDisconnected] as bool?,
      joinedAt: json[_kJoinedAt] != null
          ? DateTime.parse(json[_kJoinedAt] as String)
          : null,
      disconnectedAt: json[_kDisconnectedAt] != null
          ? DateTime.parse(json[_kDisconnectedAt] as String)
          : null,
    );
  }

  static const String _kId = 'id';
  static const String _kFullName = 'fullName';
  static const String _kBio = 'bio';
  static const String _kImageUrl = 'imageUrl';
  static const String _kBroadcastId = 'broadcastId';
  static const String _kRole = 'role';
  static const String _kNumberOfListeners = 'numberOfListeners';
  static const String _kIsHostDisconnected = 'isHostDisconnected';
  static const String _kJoinedAt = 'joinedAt';
  static const String _kDisconnectedAt = 'disconnectedAt';

  Map<String, dynamic> toJson([ParticipantRoleFormat? format]) {
    return {
      _kId: id,
      _kFullName: fullName,
      _kBio: bio,
      _kImageUrl: imageUrl,
      _kBroadcastId: broadcastId,
      _kRole: role.serialize(format: format ?? ParticipantRoleFormat.normal),
      _kNumberOfListeners: numberOfListeners,
      _kIsHostDisconnected: isHostDisconnected,
      _kJoinedAt: joinedAt?.toIso8601String(),
      _kDisconnectedAt: disconnectedAt?.toIso8601String(),
    };
  }

  final String id;
  final String fullName;
  final String? bio;
  final String? imageUrl;
  final String? broadcastId;
  final ParticipantRole role;
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
}

extension ParticipantToDomainX on ParticipantDto {
  Participant get toDomain {
    return Participant(
      id: Id.fromString(id),
      fullName: SingleLineString(fullName),
      bio: bio == null ? null : MultiLineString(bio!),
      imageUrl: imageUrl,
      broadcastId: broadcastId == null ? null : Id.fromString(broadcastId!),
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
