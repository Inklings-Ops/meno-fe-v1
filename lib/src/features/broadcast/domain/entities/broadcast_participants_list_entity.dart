import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/features.dart';

part 'broadcast_participants_list_entity.freezed.dart';

@freezed
class BroadcastParticipantsListEntity with _$BroadcastParticipantsListEntity {
  const factory BroadcastParticipantsListEntity({
    required List<BroadcastParticipant> broadcastListeners,
    required int totalItems,
    required int totalPages,
    required int currentPage,
  }) = _BroadcastParticipantsListEntity;

  factory BroadcastParticipantsListEntity.empty() {
    return const BroadcastParticipantsListEntity(
      broadcastListeners: [],
      currentPage: 1,
      totalItems: 1,
      totalPages: 1,
    );
  }
}
