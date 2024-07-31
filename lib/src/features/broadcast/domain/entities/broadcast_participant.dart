import 'package:freezed_annotation/freezed_annotation.dart';

part 'broadcast_participant.freezed.dart';

@freezed
class BroadcastParticipant with _$BroadcastParticipant {
  const factory BroadcastParticipant({
    required String id,
    required String fullName,
    String? imageUrl,
    @Default(false) bool isCreator,
    @Default(false) bool isCohost,
  }) = _BroadcastParticipant;

  factory BroadcastParticipant.empty() {
    return const BroadcastParticipant(id: '', fullName: '');
  }
}
