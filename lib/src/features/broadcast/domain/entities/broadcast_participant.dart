import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/entities/role.dart';

part 'broadcast_participant.freezed.dart';

@immutable
@freezed
class BroadcastParticipant with _$BroadcastParticipant {
  const factory BroadcastParticipant({
    required String id,
    required String fullName,
    String? broadcastId,
    Role? role,
    String? bio,
    String? imageUrl,
    int? numberOfListeners,
    bool? isHostDisconnected,
    DateTime? joinedAt,
    DateTime? disconnectedAt,
  }) = _BroadcastParticipant;

  factory BroadcastParticipant.empty() {
    return const BroadcastParticipant(id: '', fullName: '');
  }

  const BroadcastParticipant._();

  @override
  bool operator ==(Object other) =>
      other is BroadcastParticipant && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
