import 'package:equatable/equatable.dart';
import 'package:meno/shared/domain/domain.dart';

final class Participant with EquatableMixin {
  const Participant({
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

  final Id id;
  final SingleLineString fullName;
  final MultiLineString? bio;
  final String? imageUrl;
  final Id? broadcastId;
  final ParticipantRole? role;
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
