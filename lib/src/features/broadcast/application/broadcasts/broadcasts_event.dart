part of 'broadcasts_bloc.dart';

sealed class BroadcastsEvent with EquatableMixin {
  const BroadcastsEvent();

  @override
  List<Object?> get props => [];
}

final class BroadcastsFetchRequested extends BroadcastsEvent {
  const BroadcastsFetchRequested({
    required this.page,
    required this.sortBy,
    required this.orderBy,
    this.id,
    this.keywords,
    this.startTimeExists,
    this.endTimeExists,
    this.include = 'totalListeners',
    this.status,
    this.creatorId,
    this.cancelToken,
  });

  final int page;
  final String sortBy;
  final OrderBy orderBy;
  final Uid<Broadcast>? id;
  final String? keywords;
  final bool? startTimeExists;
  final bool? endTimeExists;
  final String? include;
  final String? status;
  final Uid<User>? creatorId;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [
        page,
        sortBy,
        orderBy,
        id,
        keywords,
        startTimeExists,
        endTimeExists,
        include,
        status,
        creatorId,
        cancelToken,
      ];
}

final class BroadcastsFetchMoreRequested extends BroadcastsEvent {
  const BroadcastsFetchMoreRequested();
}

final class BroadcastsKeywordsChanged extends BroadcastsEvent {
  const BroadcastsKeywordsChanged(this.keywords);
  final String keywords;

  @override
  List<Object?> get props => [keywords];
}
