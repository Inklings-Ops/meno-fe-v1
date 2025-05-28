part of 'broadcasts_bloc.dart';

enum BroadcastsStateStatus { initial, loading, failure, success, loadingMore }

extension BroadcastsStateStatusX on BroadcastsStateStatus {
  bool get isInitial => this == BroadcastsStateStatus.initial;
  bool get isLoading => this == BroadcastsStateStatus.loading;
  bool get isFailure => this == BroadcastsStateStatus.failure;
  bool get isSuccess => this == BroadcastsStateStatus.success;
  bool get isLoadingMore => this == BroadcastsStateStatus.loadingMore;
}

final class BroadcastsState with EquatableMixin {
  const BroadcastsState({
    this.broadcasts = const <Broadcast?>[],
    this.sortBy = 'title',
    this.orderBy = OrderBy.ASC,
    this.currentPage = 1,
    this.hasMore = true,
    this.totalPages,
    this.status = BroadcastsStateStatus.initial,
    this.id,
    this.keywords,
    this.startTimeExists,
    this.endTimeExists,
    this.include = 'totalListeners',
    this.broadcastStatus,
    this.creatorId,
    this.exception,
  });

  final List<Broadcast?> broadcasts;
  final int currentPage;
  final bool hasMore;
  final int? totalPages;
  final BroadcastsStateStatus status;

  final String sortBy;
  final OrderBy orderBy;
  final ID? id;
  final String? keywords;
  final bool? startTimeExists;
  final bool? endTimeExists;
  final String? include;
  final String? broadcastStatus;
  final ID? creatorId;

  final BroadcastException? exception;

  @override
  List<Object?> get props => [
        broadcasts,
        currentPage,
        hasMore,
        totalPages,
        status,
        sortBy,
        orderBy,
        id,
        keywords,
        startTimeExists,
        endTimeExists,
        include,
        broadcastStatus,
        creatorId,
        exception,
      ];
  BroadcastsState copyWith({
    List<Broadcast?>? broadcasts,
    int? currentPage,
    bool? hasMore,
    int? totalPages,
    BroadcastsStateStatus? status,
    String? sortBy,
    OrderBy? orderBy,
    ID? id,
    String? keywords,
    bool? startTimeExists,
    bool? endTimeExists,
    String? include,
    String? broadcastStatus,
    ID? creatorId,
    BroadcastException? exception,
  }) {
    return BroadcastsState(
      broadcasts: broadcasts ?? this.broadcasts,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      totalPages: totalPages ?? this.totalPages,
      status: status ?? this.status,
      sortBy: sortBy ?? this.sortBy,
      orderBy: orderBy ?? this.orderBy,
      id: id ?? this.id,
      keywords: keywords ?? this.keywords,
      startTimeExists: startTimeExists ?? this.startTimeExists,
      endTimeExists: endTimeExists ?? this.endTimeExists,
      include: include ?? this.include,
      broadcastStatus: broadcastStatus ?? this.broadcastStatus,
      creatorId: creatorId ?? this.creatorId,
      exception: exception ?? this.exception,
    );
  }
}

// sealed class BroadcastsState with EquatableMixin {
//   const BroadcastsState();

//   @override
//   List<Object?> get props => [];
// }

// final class BroadcastsInitial extends BroadcastsState {
//   const BroadcastsInitial();
// }

// final class BroadcastsLoadInProgress extends BroadcastsState {
//   const BroadcastsLoadInProgress();
// }

// final class BroadcastsLoadSuccess extends BroadcastsState {
//   const BroadcastsLoadSuccess({
//     required this.broadcasts,
//     this.currentPage = 1,
//     this.hasMore = true,
//     this.totalPages,
//   });

//   final List<Broadcast?> broadcasts;
//   final int currentPage;
//   final bool hasMore;
//   final int? totalPages;

//   @override
//   List<Object?> get props => [broadcasts, currentPage, hasMore, totalPages];
// }

// final class BroadcastsLoadMoreInProgress extends BroadcastsState {
//   const BroadcastsLoadMoreInProgress(this.broadcasts);
//   final List<Broadcast?> broadcasts;

//   @override
//   List<Object?> get props => [broadcasts];
// }

// final class BroadcastsLoadFailure extends BroadcastsState {
//   const BroadcastsLoadFailure(this.exception);
//   final BroadcastException exception;

//   @override
//   List<Object?> get props => [exception];
// }
