part of 'users_recent_broadcasts_bloc.dart';

sealed class UsersRecentBroadcastsState with EquatableMixin {
  const UsersRecentBroadcastsState();

  @override
  List<Object?> get props => [];
}

final class UsersRecentBroadcastsInitial extends UsersRecentBroadcastsState {
  const UsersRecentBroadcastsInitial();
}

final class UsersRecentBroadcastsEmpty extends UsersRecentBroadcastsState {
  const UsersRecentBroadcastsEmpty();
}

final class UsersRecentBroadcastsLoadInProgress
    extends UsersRecentBroadcastsState {
  const UsersRecentBroadcastsLoadInProgress();
}

final class UsersRecentBroadcastsLoadMoreInProgress
    extends UsersRecentBroadcastsState {
  const UsersRecentBroadcastsLoadMoreInProgress(this.broadcasts);
  final List<Broadcast?> broadcasts;

  @override
  List<Object?> get props => [broadcasts];
}

final class UsersRecentBroadcastsLoadSuccess
    extends UsersRecentBroadcastsState {
  const UsersRecentBroadcastsLoadSuccess({
    required this.broadcasts,
    this.currentPage = 1,
  });

  final List<Broadcast?> broadcasts;
  final int currentPage;

  @override
  List<Object?> get props => [broadcasts, currentPage];
}

final class UsersRecentBroadcastsLoadLastSuccess
    extends UsersRecentBroadcastsState {
  const UsersRecentBroadcastsLoadLastSuccess(this.broadcasts);
  final List<Broadcast?> broadcasts;

  @override
  List<Object?> get props => [broadcasts];
}

final class UsersRecentBroadcastsLoadFailure
    extends UsersRecentBroadcastsState {
  const UsersRecentBroadcastsLoadFailure(this.exception);
  final BroadcastException exception;

  @override
  List<Object?> get props => [exception];
}
