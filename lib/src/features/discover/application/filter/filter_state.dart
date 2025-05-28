part of 'filter_bloc.dart';

final class FilterState with EquatableMixin {
  const FilterState({
    this.filter = Filter.all,
    this.searchMap = const {Filter.all: []},
    this.page = 1,
    this.isLoading = false,
    this.hasMore = true,
    this.exception,
  });

  final Filter filter;
  final Map<Filter, List<Broadcast?>> searchMap;
  final int page;
  final bool isLoading;
  final bool hasMore;
  final BroadcastException? exception;
  FilterState copyWith({
    Filter? filter,
    Map<Filter, List<Broadcast?>>? searchMap,
    int? page,
    bool? isLoading,
    bool? hasMore,
    BroadcastException? exception,
  }) {
    return FilterState(
      filter: filter ?? this.filter,
      searchMap: searchMap ?? this.searchMap,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [
        filter,
        searchMap,
        page,
        isLoading,
        hasMore,
        exception,
      ];
}
