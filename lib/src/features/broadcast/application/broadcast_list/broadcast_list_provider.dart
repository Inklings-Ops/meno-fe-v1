import 'package:meno_fe_v1/src/features/broadcast/application/broadcast_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/domain.dart';

part 'broadcast_list_provider.g.dart';

@riverpod
Future<List<Broadcast?>> recentBroadcasts(
  RecentBroadcastsRef ref, {
  int? limit,
}) async {
  const AsyncValue.loading();

  // final today = DateTime.now();
  // final twoDaysAgo = today.subtract(const Duration(days: 2));

  final result = await ref.read(broadcastFacadeProvider).getBroadcasts(
        // endTimeGT: twoDaysAgo.toIso8601String(),
        // endTimeLT: today.toIso8601String(),
        orderBy: "ASC",
        sortBy: "endTime",
        size: limit,
      );

  return result.fold((l) => [], (List<Broadcast?> r) => r);
}

@riverpod
class BroadcastList extends _$BroadcastList {
  @override
  AsyncValue<List<Broadcast?>> build() => const AsyncValue.data([]);

  IBroadcastFacade get _facade => ref.read(broadcastFacadeProvider);

  Future<void> recentBroadcasts([int? limit]) async {
    state = const AsyncValue.loading();

    final today = DateTime.now();
    final twoDaysAgo = today.subtract(const Duration(days: 2));

    final result = await _facade.getBroadcasts(
      endTimeGT: twoDaysAgo.toIso8601String(),
      endTimeLT: today.toIso8601String(),
      size: limit,
    );

    state = result.fold(
      (l) => AsyncValue.error(l, StackTrace.current),
      (r) => AsyncValue.data(r),
    );
  }
}
