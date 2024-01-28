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
        size: limit,
        orderBy: 'DESC',
        sortBy: 'startTime',
        // endTimeGT: twoDaysAgo.toIso8601String(),
      );

  return result.fold((l) => [], (List<Broadcast?> r) => r);
}

@riverpod
Future<List<Broadcast?>> myRecentBroadcasts(
  MyRecentBroadcastsRef ref, {
  int? limit,
}) async {
  const AsyncValue.loading();

  final today = DateTime.now();
  final twoDaysAgo = today.subtract(const Duration(days: 2));

  final result = await ref.read(broadcastFacadeProvider).getBroadcasts(
        size: limit,
        orderBy: 'DESC',
        sortBy: 'startTime',
        endTimeGT: twoDaysAgo.toIso8601String(),
      );

  return result.fold((l) => [], (List<Broadcast?> r) => r);
}

@riverpod
class BroadcastList extends _$BroadcastList {
  @override
  Future<List<Broadcast?>> build() async => [];

  Future<void> recentBroadcasts([int? limit]) async {
    state = const AsyncValue.loading();

    final today = DateTime.now();
    final twoDaysAgo = today.subtract(const Duration(days: 2));

    final result = await ref.read(broadcastFacadeProvider).getBroadcasts(
          size: limit,
          orderBy: 'DESC',
          sortBy: 'startTime',
          endTimeGT: twoDaysAgo.toIso8601String(),
        );

    state = result.fold(
      (l) => AsyncValue.error(l, StackTrace.current),
      (r) => AsyncValue.data(r),
    );
  }
}
