import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/broadcast/domain/entities/broadcast.dart';

part 'broadcast_list_entity.freezed.dart';

@freezed
class BroadcastListEntity with _$BroadcastListEntity {
  const factory BroadcastListEntity({
    required List<Broadcast?> broadcasts,
    required int totalItems,
    required int totalPages,
    required int currentPage,
  }) = _BroadcastListEntity;

  factory BroadcastListEntity.empty() {
    return const BroadcastListEntity(
      broadcasts: [],
      currentPage: 1,
      totalItems: 1,
      totalPages: 1,
    );
  }
}
