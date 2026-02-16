import 'package:equatable/equatable.dart';
import 'package:meno/shared/domain/domain.dart';

final class Participant with EquatableMixin {
  const Participant({
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

  final Id id;
  final SingleLineString fullName;
  final MultiLineString? bio;
  final String? imageUrl;
  final Id? broadcastId;
  final ParticipantRole role;
  final int? numberOfListeners;
  final bool? isHostDisconnected;
  final DateTime? joinedAt;
  final DateTime? disconnectedAt;

  static Participant empty = const Participant(
    id: Id.empty,
    fullName: SingleLineString.empty,
  );

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

final fakeParticipants = List.filled(
  3,
  Participant(
    id: Id.fromString('1'),
    fullName: SingleLineString('name'),
    bio: MultiLineString('bio'),
    imageUrl: 'imageUrl',
    broadcastId: Id.fromString('broadcastId'),
    role: ParticipantRole.host,
    numberOfListeners: 100,
    isHostDisconnected: true,
  ),
);

extension ParticipantBoolX on Participant {
  bool get isHost => role.isHost;

  bool get isCohost => role.isCohost;

  bool get isListener => role.isListener;
}
