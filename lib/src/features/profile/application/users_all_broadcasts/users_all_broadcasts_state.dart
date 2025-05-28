part of 'users_all_broadcasts_bloc.dart';

sealed class UsersAllBroadcastsState with EquatableMixin {
  const UsersAllBroadcastsState();

  @override
  List<Object?> get props => [];
}

final class UsersAllBroadcastsInitial extends UsersAllBroadcastsState {
  const UsersAllBroadcastsInitial();
}

final class UsersAllBroadcastsEmpty extends UsersAllBroadcastsState {
  const UsersAllBroadcastsEmpty();
}

final class UsersAllBroadcastsLoadInProgress extends UsersAllBroadcastsState {
  const UsersAllBroadcastsLoadInProgress();
}

final class UsersAllBroadcastsLoadMoreInProgress
    extends UsersAllBroadcastsState {
  const UsersAllBroadcastsLoadMoreInProgress(this.broadcasts);
  final List<Broadcast?> broadcasts;

  @override
  List<Object?> get props => [broadcasts];
}

final class UsersAllBroadcastsLoadSuccess extends UsersAllBroadcastsState {
  const UsersAllBroadcastsLoadSuccess({
    required this.broadcasts,
    this.currentPage = 1,
  });

  final List<Broadcast?> broadcasts;
  final int currentPage;

  @override
  List<Object?> get props => [broadcasts, currentPage];
}

final class UsersAllBroadcastsLoadLastSuccess extends UsersAllBroadcastsState {
  const UsersAllBroadcastsLoadLastSuccess(this.broadcasts);
  final List<Broadcast?> broadcasts;

  @override
  List<Object?> get props => [broadcasts];
}

final class UsersAllBroadcastsLoadFailure extends UsersAllBroadcastsState {
  const UsersAllBroadcastsLoadFailure(this.exception);
  final BroadcastException exception;

  @override
  List<Object?> get props => [exception];
}
