part of 'now_live_bloc.dart';

sealed class NowLiveState with EquatableMixin {
  const NowLiveState();

  @override
  List<Object?> get props => [];
}

final class NowLiveInitial extends NowLiveState {
  const NowLiveInitial();
}

final class NowLiveLoadInProgress extends NowLiveState {
  const NowLiveLoadInProgress();
}

final class NowLiveLoadMoreInProgress extends NowLiveState {
  const NowLiveLoadMoreInProgress(this.broadcasts);
  final List<Broadcast?> broadcasts;

  @override
  List<Object?> get props => [broadcasts];
}

final class NowLiveLoadFailure extends NowLiveState {
  const NowLiveLoadFailure(this.exception);
  final BroadcastException exception;

  @override
  List<Object?> get props => [exception];
}

final class NowLiveLoadSuccess extends NowLiveState {
  const NowLiveLoadSuccess({
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
