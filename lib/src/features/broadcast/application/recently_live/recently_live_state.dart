part of 'recently_live_bloc.dart';

sealed class RecentlyLiveState with EquatableMixin {
  const RecentlyLiveState();

  @override
  List<Object?> get props => [];
}

final class RecentlyLiveInitial extends RecentlyLiveState {
  const RecentlyLiveInitial();
}

final class RecentlyLiveLoadInProgress extends RecentlyLiveState {
  const RecentlyLiveLoadInProgress();
}

final class RecentlyLiveLoadMoreInProgress extends RecentlyLiveState {
  const RecentlyLiveLoadMoreInProgress(this.broadcasts);
  final List<Broadcast?> broadcasts;

  @override
  List<Object?> get props => [broadcasts];
}

final class RecentlyLiveLoadFailure extends RecentlyLiveState {
  const RecentlyLiveLoadFailure(this.exception);
  final BroadcastException exception;

  @override
  List<Object?> get props => [exception];
}

final class RecentlyLiveLoadSuccess extends RecentlyLiveState {
  const RecentlyLiveLoadSuccess({
    required this.broadcasts,
    required this.currentPage,
    required this.hasMore,
  });
  
  final List<Broadcast?> broadcasts;
  final int currentPage;
  final bool hasMore;

  @override
  List<Object?> get props => [broadcasts, currentPage, hasMore];
}
