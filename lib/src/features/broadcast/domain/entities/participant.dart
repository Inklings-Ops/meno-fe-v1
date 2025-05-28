// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

enum ParticipantRole { host, cohost, listener, HOST, COHOST, LISTENER }

class Participant with EquatableMixin {
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

  final ID id;
  final SingleLineString fullName;
  final MultiLineString? bio;
  final String? imageUrl;
  final ID? broadcastId;
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
    return other is Participant && other.id == id;
  }

  /// Overrides the hashCode to be consistent with the custom '==' operator,
  /// using only the 'id' for hashing.
  @override
  int get hashCode => id.hashCode;
}
